module Scenic
  module Adapters
    class Mysql
      # Raised when a materialized view operation is attempted on a database
      # version that does not support materialized views.
      #
      # Materialized views are not supported on Mysql.
      class MaterializedViewsNotSupportedError < StandardError
        def initialize
          super('Materialized views not supported in Mysql')
        end
      end

      # Raised when attempting a concurrent materialized view refresh on a
      # database version that does not support that.
      #
      # Materialized views are not supported on Mysql.
      class ConcurrentRefreshesNotSupportedError < MaterializedViewsNotSupportedError
        def initialize
          super
        end
      end
    end
  end
end
