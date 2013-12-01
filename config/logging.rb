file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
file.sync = true

use Rack::CommonLogger, file
ActiveRecord::Base.logger = Logger.new(file)
