require 'rake'
require 'sinatra/activerecord/rake'

namespace :s3 do
  desc 'set s3 rule for CORS'
  task :enable_cors do
    S3.set_rules
  end
end

# important to be at last for task definitions to work
require './app'
