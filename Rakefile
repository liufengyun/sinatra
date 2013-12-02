require "sinatra/activerecord/rake"
require "./app"

namespace :s3 do
  desc 'set s3 rule for CORS'
  task :enable_cors => :environment do
    S3.set_rules
  end
end