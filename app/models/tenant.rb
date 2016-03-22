class Tenant < ActiveRecord::Base

  after_create :initialize_apartment_schema
  after_destroy :drop_apartment_schema

  validates :domain, presence: true, uniqueness: true
  validates :database_name, presence: true, uniqueness: true

  def self.current_tenant
    Tenant.where({ database_name: Apartment::Database.current_tenant }).first
  end

  def self.mel_catalog_enabled
    tenant = self.current_tenant    
    if !tenant.present?
      return false
    else
      return tenant.mel_catalog_enabled?
    end
  end

  def self.annotation_categories_enabled
    tenant = self.current_tenant    
    if !tenant.present?
      return false
    else
      return tenant.annotation_categories_enabled?
    end
  end


  def initialize_apartment_schema
    return if database_name == 'public'
    
    begin
      Apartment::Database.create(database_name)
    rescue Apartment::TenantExists => e
      Rails.logger.warn "Schema already existed: #{e.inspect}"
    end
  end

  def drop_apartment_schema
    return if database_name == 'public'

    begin
      Apartment::Database.drop(database_name)
    rescue Apartment::TenantNotFound => e
      Rails.logger.warn "Schema can't be destroyed as it wasn't there: #{e.inspect}"
    end
  end
end
