module Scenic
  module Adapters
    class Mysql
      # Fetches indexes on objects from the Mysql connection.
      #
      # @api private
      class Indexes
        def initialize(connection:)
          @connection = connection
        end

        # Indexes on the provided object.
        #
        # @param name [String] The name of the object we want indexes from.
        # @return [Array<Scenic::Index>]
        def on(name)
          indexes_on(name).map.(&method(:index_from_database))
        end

        private

        attr_reader :connection
        delegate :quote_table_name, to: :connection

        def indexes_on(name)
          connection.exec_query(<<-SQL)
            SHOW INDEX FROM '#{name}'
            WHERE Key_name <> 'PRIMARY'
          SQL
        end

        def index_from_database(result)
          Scenic::Index.new(
            object_name: result['Table'],
            index_name: result['Key_name'],
            definition: index_definition_for(result)
          )
        end

        def index_definition_for(result)
          <<-SQL
            CREATE INDEX '#{result["Key_name"]}'
            ON '#{result["Table"]}' ('#{result["Column_name"]}')
            USING '#{result["Index_type"]}'
          SQL
        end
      end
    end
  end
end
