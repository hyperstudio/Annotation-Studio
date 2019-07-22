require 'spec_helper'

describe Tenant do
  it { should validate_uniqueness_of :database_name }
  it { should validate_presence_of :database_name }
  it { should validate_presence_of :domain }
  it { should validate_uniqueness_of :domain }

  it 'should create a schema after it is created' do
    tenant = build(:tenant, database_name: 'frapples')

    Apartment::Tenant.stub(:drop)
    Apartment::Tenant.should_receive(:create).with(tenant.database_name)

    tenant.save
  end

  it 'should destroy the schema when the tenant is destroyed' do
    tenant = create(:tenant, database_name: 'frapples')

    Apartment::Tenant.stub(:create)
    Apartment::Tenant.should_receive(:drop).with(tenant.database_name)

    tenant.destroy
  end
end
