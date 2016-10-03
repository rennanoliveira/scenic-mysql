module Scenic
  module Adapters
    class Mysql
      # Fetches defined views from the mysql connection.
      # @api private
      class Views
        def initialize(connection)
          @connection = connection
        end

        # All of the views that this connection has defined.
        # Mysql will return these views ordered by name.
        # Difference from the original Postgres adapter:
        #   Mysql2 gem only watches one schema at a time.
        #
        # This will not include materialized views as these are not
        # supported by mysql.
        #
        # @return [Array<Scenic::View>]
        def all
          views_from_mysql.map(&method(:to_scenic_view))
        end

        private

        attr_reader :connection

        def views_from_mysql
          ActiveRecord::Base.connection.exec_query(<<-SQL)
		        SELECT TABLE_NAME, VIEW_DEFINITION, TABLE_SCHEMA
  			    FROM information_schema.VIEWS
			      WHERE TABLE_SCHEMA = DATABASE();
          SQL
        end

        def to_scenic_view(result)
          Scenic::View.new(
            name: result['TABLE_NAME'],
            definition: result['VIEW_DEFINITION'].strip,
            materialized: false
          )
        end

      end
    end
  end
end
