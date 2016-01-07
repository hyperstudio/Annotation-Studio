class Tenant < ActiveRecord::Base
  attr_accessible :database_name, :domain

  attr_accessible :mel_catalog_enabled, :mel_catalog_enabled
  attr_accessible :mel_catalog_url, :mel_catalog_url
  attr_accessible :annotation_categories_enabled, :annotation_categories_enabled

  after_create :initialize_apartment_schema
  after_destroy :drop_apartment_schema

  validates :domain, presence: true, uniqueness: true
  validates :database_name, presence: true, uniqueness: true

  def initialize_apartment_schema
    begin
      Apartment::Database.create(database_name)
    rescue Apartment::SchemaExists => e
      Rails.logger.warn "Schema already existed: #{e.inspect}"
    end
  end

  def drop_apartment_schema
    begin
      Apartment::Database.drop(database_name)
    rescue Apartment::SchemaNotFound => e
      Rails.logger.warn "Schema can't be destroyed as it wasn't there: #{e.inspect}"
    end
  end
end
