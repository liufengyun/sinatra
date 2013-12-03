ENV["RACK_ENV"] ||= 'test'

app_file = File.join(File.dirname(__FILE__), *%w[.. .. app.rb])
require app_file
# Force the application name because polyglot breaks the auto-detection logic.
Sinatra::Application.app_file = app_file

require 'rspec/expectations'
require 'rack/test'

# disable logging
ActiveRecord::Base.logger = nil

World do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  app
end

DatabaseCleaner.strategy = :truncation

Before do
  DatabaseCleaner.start
end

After do |scenario|
  DatabaseCleaner.clean
end