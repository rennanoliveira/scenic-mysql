require 'spec_helper'

module Scenic
  module Adapters
    describe Mysql::Connection do
      describe 'supports_materialized_views?' do
        it 'is false' do
          connection = Mysql::Connection.new('')
          expect(connection.supports_materialized_views?).to be false
        end
      end

      describe '#supports_concurrent_refreshes?' do
        it 'is false' do
          connection = Mysql::Connection.new('')

          expect(connection.supports_concurrent_refreshes?).to be false
        end
      end
    end
  end
end
