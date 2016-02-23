class AddTenantConfigFields < ActiveRecord::Migration
  def change
    add_column :tenants, :mel_catalog_enabled, :boolean, :default => false
    add_column :tenants, :annotation_categories_enabled, :boolean, :default => false
    add_column :tenants, :mel_catalog_url, :string
  end
end
