source "http://rubygems.org/"

gem "sinatra"
gem "sinatra-contrib"

# parse post body json
gem 'rack-parser', :require => 'rack/parser'

gem "activerecord", "~> 4.0"
gem "sinatra-activerecord"
gem "pg"

# oj is 10x faster in json dumping
gem "oj"

# handle s3 files
gem "aws-sdk"

gem "thin"

# utitlity
gem 'hashie'

# setup our test group and require rspec
group :test do
  gem "rspec"
  gem "cucumber"
  gem "jsonpath", :git => "git@github.com:liufengyun/jsonpath.git", :branch => "filter"
  gem "database_cleaner"
  gem "nokogiri"
  gem "rack-test"
end
