class DropExtensionPgStatStatements < ActiveRecord::Migration
  def self.up
    disable_extension "pg_stat_statements"
  end
end
