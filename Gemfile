source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails', '>= 3.2.12'
gem 'unicorn'

gem 'pg'
gem "newrelic_rpm"#, "~> 3.5.7.59"

gem 'devise'#, '>= 2.2.2'
gem 'cancan'
gem 'repertoire-groups', '0.0.1', :path => 'vendor/repertoire-groups-0.0.1' #, :require => 'repertoire-groups'
gem 'acts-as-taggable-on', '~> 3.0.2' # Note: 3.1.1 breaks the database TODO: Check later for updates.
gem "friendly_id"#, ">= 4.0.9"
gem "babosa"
gem 'high_voltage', '~> 2.1.0'
gem "aws-sdk"
gem "paperclip"
gem "delayed_job_active_record"
gem 'pdf-reader'
gem 'pdf-reader-html'
gem 'yomu'
gem 'apartment'

group :development do
  gem 'sextant'
  gem 'meta_request'#, '0.2.1'
  gem 'highline'
  gem 'foreman'
end

group :assets do
  gem "therubyracer"
  gem 'less-rails' #,   '~> 3.2.3'
  gem 'coffee-rails' #, '~> 3.2.1'
  gem 'uglifier' #, '>= 1.0.3'
end

group :test, :development do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'pry-rails'
  gem 'capybara-webkit'
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

gem "fog", "~> 1.3.1"
gem "mini_magick"
gem "carrierwave"
# gem "carrierwave_direct"
# gem "sidekiq"


gem 'jbuilder'
gem "jwt" #, "~> 0.1.4"
gem "rabl"
gem "gon"
gem "nokogiri"

gem 'activeadmin'
gem 'sass-rails'
gem "meta_search"#,    '>= 1.1.0.pre'

gem "figaro"

gem 'will_paginate', '> 3.0'
gem 'runtimeerror_notifier'
gem 'intercom-rails'

gem "melcatalog", :path => "vendor"
gem "rest-client"

gem "doorkeeper"
