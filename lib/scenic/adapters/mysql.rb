require_relative 'mysql/connection'
require_relative 'mysql/errors'
require_relative 'mysql/indexes'
require_relative 'mysql/views'

module Scenic
  # Scenic database adapters.
  #
  # Scenic ships with a Postgres adapter only but can be extended with
  # additional adapters. This adapter {Adapters::Mysql} implements the
  # interface described on {Adapters::Postgres}.
  module Adapters
    # An adapter for managing Mysql views.
    #
    # These methods are used internally by Scenic and are not intended for direct
    # use. Methods that alter database schema are intended to be called via
    # {Statements}, while {#refresh_materialized_view} is called via
    # {Scenic.database}.
    #
    # The methods are documented here for insight into specifics of how Scenic
    # integrates with Mysql and the responsibilities of {Adapters}.
    class Mysql
      # Creates an instance of the Scenic Mysql adapter.
      #
      # Postgres is the default adapter for Scenic. To use this Mysql adapter,
      # follow the example bellow
      #
      # @param [#connection] connectable An object that returns the connection
      #   for Scenic to use. Defaults to `ActiveRecord::Base`.
      #
      # @example
      #  Scenic.configure do |config|
      #    config.adapter = Scenic::Adapters::Mysql.new
      #  end
      def initialize(connectable = ActiveRecord::Base)
        @connectable = connectable
      end

      # Returns an array of views in the database.
      #
      # This collection of views is used by the [Scenic::SchemaDumper] to
      # populate the `schema.rb` file.
      #
      # @return [Array<Scenic::View>]
      def views
        Views.new(connection).all
      end

      # Creates a view in the database.
      #
      # This is typically called in a migration via {Statements#create_view}.
      #
      # @param name The name of the view to create
      # @param sql_definition The SQL schema for the view.
      #
      # @return [void]
      def create_view(name, sql_definition)
        execute "CREATE VIEW #{quote_table_name(name)} AS #{sql_definition};"
      end

      # Updates a view in the database.
      #
      # This results in a {#drop_view} followed by a {#create_view}. The
      # explicitness of that two step process is preferred to `CREATE OR
      # REPLACE VIEW` because the former ensures that the view you are trying to
      # update did, in fact, already exist. Additionally, `CREATE OR REPLACE
      # VIEW` is allowed only to add new columns to the end of an existing
      # view schema. Existing columns cannot be re-ordered, removed, or have
      # their types changed. Drop and create overcomes this limitation as well.
      #
      # This is typically called in a migration via {Statements#update_view}.
      #
      # @param name The name of the view to update
      # @param sql_definition The SQL schema for the updated view.
      #
      # @return [void]
      def update_view(name, sql_definition)
        drop_view(name)
        create_view(name, sql_definition)
      end

      # Replaces a view in the database using `CREATE OR REPLACE VIEW`.
      #
      # This results in a `CREATE OR REPLACE VIEW`. Most of the time the
      # explicitness of the two step process used in {#update_view} is preferred
      # to `CREATE OR REPLACE VIEW` because the former ensures that the view you
      # are trying to update did, in fact, already exist. Additionally,
      # `CREATE OR REPLACE VIEW` is allowed only to add new columns to the end
      # of an existing view schema. Existing columns cannot be re-ordered,
      # removed, or have their types changed. Drop and create overcomes this
      # limitation as well.
      #
      # However, when there is a tangled dependency tree
      # `CREATE OR REPLACE VIEW` can be preferable.
      #
      # This is typically called in a migration via
      # {Statements#replace_view}.
      #
      # @param name The name of the view to update
      # @param sql_definition The SQL schema for the updated view.
      #
      # @return [void]
      def replace_view(name, sql_definition)
        execute "CREATE OR REPLACE VIEW #{quote_table_name(name)} AS #{sql_definition};"
      end

      # Drops the named view from the database
      #
      # This is typically called in a migration via {Statements#drop_view}.
      #
      # @param name The name of the view to drop
      #
      # @return [void]
      def drop_view(name)
        execute "DROP VIEW #{quote_table_name(name)};"
      end

      # @raise [MaterializedViewsNotSupportedError] as Mysql does not support
      # materialized views.
      #
      # @return [void]
      def create_materialized_view(_name, _sql_definition)
        raise MaterializedViewsNotSupportedError
      end

      # @raise [MaterializedViewsNotSupportedError] as Mysql does not support
      # materialized views.
      #
      # @return [void]
      def update_materialized_view(_name, _sql_definition)
        raise MaterializedViewsNotSupportedError
      end


      # @raise [MaterializedViewsNotSupportedError] as Mysql does not support
      # materialized views.
      #
      # @return [void]
      def drop_materialized_view(_name)
        raise MaterializedViewsNotSupportedError
      end


      # @raise [MaterializedViewsNotSupportedError] as Mysql does not support
      # materialized views.
      #
      # @return [void]
      def refresh_materialized_view(_name, _concurrently: false)
        raise MaterializedViewsNotSupportedError
      end

      private

      attr_reader :connectable
      delegate :execute, :quote_table_name, to: :connection

      def connection
        connectable.connection
      end

    end
  end
end
