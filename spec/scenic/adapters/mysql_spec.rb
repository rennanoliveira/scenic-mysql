require 'spec_helper'

module Scenic
  module Adapters
    describe Mysql, :db do
      describe '#create_view' do
        it 'successfully creates a view' do
          adapter = Mysql.new

          adapter.create_view('greetings', "SELECT 'hi' AS greeting")
          adapter_views = adapter.views

          expect(adapter_views.map(&:name)).to include('greetings')
        end
      end

      describe '#create_materialized_view' do
        it 'raises an exception as Mysql does not support them' do
          adapter = Mysql.new
          err = Scenic::Adapters::Mysql::MaterializedViewsNotSupportedError

          expect { adapter.create_materialized_view('greetings', 'select 1') }
              .to raise_error err
        end
      end

      describe '#replace_view' do
        it 'successfully replaces a view' do
          adapter = Mysql.new

          adapter.create_view('greetings', "SELECT 'hi' AS greeting")
          adapter.replace_view('greetings', "SELECT 'hello' AS greeting")

          view = adapter.views.first.definition

          expect(view).to eql "select 'hello' AS `greeting`"
        end
      end

      describe '#drop_view' do
        it 'successfully drops a view' do
          adapter = Mysql.new

          adapter.create_view('greetings', "SELECT 'hi' AS greeting")
          adapter.drop_view('greetings')

          expect(adapter.views.map(&:name)).not_to include('greetings')
        end
      end

      describe '#drop_materialized_view' do
        it 'raises an exception as Mysql does not support them' do
          adapter = Mysql.new('')
          err = Scenic::Adapters::Mysql::MaterializedViewsNotSupportedError

          expect { adapter.drop_materialized_view('greetings') }
              .to raise_error err
        end
      end

      describe '#refresh_materialized_view' do
        it 'raises an exception as Mysql does not support them' do
          adapter = Mysql.new('')
          err = Scenic::Adapters::Mysql::MaterializedViewsNotSupportedError

          expect { adapter.refresh_materialized_view(:tests) }
              .to raise_error err
        end
      end

      describe '#views' do
        it 'returns the views defined on this connection' do
          adapter = Mysql.new

          ActiveRecord::Base.connection.execute <<-SQL
            CREATE VIEW parents AS SELECT 'Joe' AS name
          SQL

          ActiveRecord::Base.connection.execute <<-SQL
            CREATE VIEW children AS SELECT 'Owen' AS name
          SQL

          expect(adapter.views.map(&:name)).
              to eq %w(children parents)
        end
      end

    end
  end
end
