require 'spec_helper'

module Scenic
  module Adapters
    describe Mysql::Views, :db do
      describe '#all' do
        it 'returns scenic view objects for views in schema' do
          connection = ActiveRecord::Base.connection
          connection.execute <<-SQL
            CREATE VIEW children AS SELECT 'Elliot' AS name
          SQL

          views = Mysql::Views.new(connection).all
          first = views.first

          expect(views.size).to eq 1
          expect(first.name).to eq 'children'
          expect(first.materialized).to be false
          expect(first.definition).to eq "select 'Elliot' AS `name`"
        end
      end
    end
  end
end
