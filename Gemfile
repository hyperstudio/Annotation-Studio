  source 'https://rubygems.org'

ruby '2.4.9'

gem 'rails', '5.0.7.2'
gem 'rack', '2.0.7'
gem 'puma'

gem 'pg'

gem 'scout_apm'

gem 'devise', '4.7.1'
gem "switch_user"
gem 'cancancan', '~> 1.10'
gem 'repertoire-groups', '0.0.1', :path => 'vendor/repertoire-groups-0.0.1'
gem 'acts-as-taggable-on', '4.0.0'
gem "friendly_id"
gem "babosa"
gem 'high_voltage', '3.1.0'
gem "aws-sdk", '< 2.0'
gem "aws-sdk-s3"
gem "paperclip"
gem "delayed_job_active_record", '4.1.3'
gem 'pdf-reader'
gem 'pdf-reader-html'
gem 'public_suffix', '3.0.3'
gem 'apartment', :git => "git://github.com/influitive/apartment.git", :branch => "development"
gem 'yomu'
gem 'net-ssh'
gem 'select2-rails', '< 4.0'
gem 'omniauth-oauth2', '1.6.0'
gem 'omniauth-wordpress_hosted', github: 'jwickard/omniauth-wordpress-oauth2-plugin'

platforms :mingw, :mswin do
  gem 'tzinfo-data'
end

group :development do
  gem 'sextant'
  gem 'meta_request', '0.7.0'
  gem 'highline'
  gem 'figaro'
end

group :assets do
  gem "therubyracer", '0.12.3', :platforms => :ruby
  gem 'coffee-rails', '4.2.2'
  gem 'uglifier'
  gem 'underscore-rails'
  gem 'backbone-on-rails'
  gem 'mustache'
end

group :test, :development do
  gem 'factory_girl_rails'
  gem 'rspec-rails', '3.8.2'
  gem 'pry-rails'
  gem 'spring'
  gem 'simplecov'
  gem 'rails_best_practices'
  gem 'launchy'
  gem 'shoulda-matchers', require: false
  gem 'database_cleaner'
end

group :production do
  gem 'rails_12factor'
end

gem 'jquery-rails', '4.3.5'
gem 'jquery-ui-rails'
gem 'tinymce-rails'

gem 'xmlrpc'
gem "fog"
gem "mini_magick"
gem "carrierwave"

gem 'jbuilder', '2.7.0'
gem "jwt"
gem "rabl"
gem "gon", '6.2.0'
gem "nokogiri", '1.9.1'

gem 'tilt', '1.1'
gem 'sass-rails', '5.0.7'
gem 'activeadmin', '1.0.0.pre5'

gem 'will_paginate', '3.1.7'
gem 'will_paginate-bootstrap'

gem 'exception_notification'

gem "rest-client"

gem "doorkeeper", "5.0.0"
gem "octokit", "~> 4.0"
