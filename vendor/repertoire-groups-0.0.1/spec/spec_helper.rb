$LOAD_PATH << "." unless $LOAD_PATH.include?(".")

require 'rubygems'
require 'bundler/setup'
require 'factory_girl'
require 'faker'

Bundler.require(:default)

# Note to self: this is required to include ActiveRecord (and Repertoire!)
# and I assume a bunch of other relevant libraries.  Otherwise you have to
# explicitly require them in this file to get rake rspec task to run.
require File.expand_path('../../lib/repertoire-groups', __FILE__)

# Models...is there a way to include all of these at once?
# And shouldn't the Engine class be including these, or no?
require File.expand_path('../../app/models/user_set', __FILE__)
require File.expand_path('../../app/models/role', __FILE__)
require File.expand_path('../../app/models/assignment', __FILE__)
require File.expand_path('../../app/helpers/groups_helper', __FILE__)

RSpec.configure do |config|
  config.mock_with :rspec
  config.before(:each) do
  end
end


# Database config

ENV['DB'] ||= 'postgresql'

database_yml = File.expand_path('../database.yml', __FILE__)
if File.exists?(database_yml)
  active_record_configuration = YAML.load_file(database_yml)[ENV['DB']]

  ActiveRecord::Base.establish_connection(active_record_configuration)
  ActiveRecord::Base.logger = Logger.new(File.join(File.dirname(__FILE__), "debug.log"))
  
  ActiveRecord::Base.silence do
    ActiveRecord::Migration.verbose = false
    
    load(File.dirname(__FILE__) + '/schema.rb')
    load(File.dirname(__FILE__) + '/models.rb')
  end  
  
else
  raise "Please create #{database_yml} first to configure your database. Take a look at: #{database_yml}.sample"
end

def clean_database!
  models = []
  models.each do |model|
    ActiveRecord::Base.connection.execute "DELETE FROM #{model.table_name}"
  end
end

#clean_database!
