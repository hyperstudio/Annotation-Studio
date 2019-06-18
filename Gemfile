  source 'https://rubygems.org'

ruby '2.2.4'

gem 'rails', '4.2.1'
gem 'puma'

gem 'pg'

# memory profilers
gem "newrelic_rpm"#, "~> 3.5.7.59"
gem 'allocation_tracer'
gem 'derailed'
gem 'scout_apm'

gem 'devise', '~> 3.2'
gem "switch_user"
gem 'cancancan', '~> 1.10'
gem 'repertoire-groups', '0.0.1', :path => 'vendor/repertoire-groups-0.0.1' #, :require => 'repertoire-groups'
gem 'acts-as-taggable-on'
gem "friendly_id"
gem "babosa"
gem 'high_voltage', '~> 2.1.0'
gem "aws-sdk", '< 2.0'
gem "paperclip"
gem "delayed_job_active_record"
gem 'pdf-reader'
gem 'pdf-reader-html'
gem 'public_suffix', '3.0.3'
gem 'apartment', :git => "git://github.com/influitive/apartment.git", :branch => "development"
gem 'yomu'
gem 'net-ssh'
gem 'select2-rails', '< 4.0'
gem 'omniauth-oauth2', '1.3.1'
gem 'omniauth-wordpress_hosted', github: 'jwickard/omniauth-wordpress-oauth2-plugin'

group :development do
  gem 'sextant'
  gem 'meta_request'#, '0.2.1'
  gem 'highline'
  gem 'figaro'
end

group :assets do
  gem "therubyracer"
  gem 'coffee-rails' #, '~> 3.2.1'
  gem 'uglifier' #, '>= 1.0.3'
  gem 'underscore-rails'
  gem 'backbone-on-rails'
  gem 'mustache'
end

group :test, :development do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
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

gem 'jquery-rails', '~> 2.3.0'
gem 'jquery-ui-rails'
gem 'tinymce-rails'

gem "fog"
gem "mini_magick"
gem "carrierwave"

gem 'jbuilder'
gem "jwt"
gem "rabl"
gem "gon"
gem "nokogiri"

gem 'tilt', '1.1'
gem 'sass-rails', '5.0.7'
gem 'activeadmin', '1.0.0.pre1'

gem 'will_paginate', '~> 3.0.5'
gem 'will_paginate-bootstrap'

gem 'exception_notification'

gem "rest-client"

gem "doorkeeper"
gem "octokit", "~> 4.0"
