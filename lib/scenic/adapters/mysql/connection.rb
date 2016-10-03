module Scenic
  module Adapters
    class Mysql
      # Decorates an ActiveRecord connection with methods that help determine
      # the connections capabilities.
      #
      # As Mysql does not support materialized views, this class is a no-op
      #
      # @api private
      class Connection < SimpleDelegator
        # False always for Mysql
        #
        # @return [Boolean]
        def supports_materialized_views?; false; end

        # False always for Mysql
        #
        # @return [Boolean]
        def supports_concurrent_refreshes?; false; end
      end
    end
  end
end
