class RemoveMelCatalogStuff < ActiveRecord::Migration
  def change
    remove_columns :tenants, :mel_catalog_enabled, :mel_catalog_url
  end
end
