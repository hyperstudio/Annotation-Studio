require 'rails/generators/migration'

module Repertoire
  class GroupsMigrationGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    source_root File.expand_path('../templates', __FILE__)

    desc "Generates migration for groups models"

    def self.next_migration_number(path)
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    end

    def create_migration_file
      migration_template 'migration.rb', 'db/migrate/repertoire_groups_migration.rb'
    end
  end
end
