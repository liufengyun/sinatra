require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'sinatra/json'
require 'sinatra/activerecord'

Bundler.require(:default, settings.environment)

config_file_content = File.read(File.join(settings.root, "config", "application.yml"))
Configuration = Hashie::Mash.new YAML.load(ERB.new(config_file_content).result)[settings.environment.to_s]

# parse body json
use Rack::Parser, :parsers => {
  'application/json'  => Proc.new { |body| ::MultiJson.decode(body) }
}

# load configurations
Dir['./config/*.rb'].each {|file| require file }

# load models
Dir['./models/*.rb'].each {|file| require file }

# load controllers
Dir['./controllers/*.rb'].each {|file| require file }

# test route
get '/hello' do
  json success: true, message: 'hello world'
end
