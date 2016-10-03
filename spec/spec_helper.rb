ENV['RAILS_ENV'] = 'test'
require 'database_cleaner'
require_relative 'support/view_remover'

require File.expand_path('../dummy/config/environment', __FILE__)

RSpec.configure do |config|
  config.order = 'random'
  DatabaseCleaner.strategy = :transaction

  config.around(:each, db: true) do |example|
    DatabaseCleaner.start
    example.run
    DatabaseCleaner.clean
    ViewRemover::RemoveViews.run
  end

end
