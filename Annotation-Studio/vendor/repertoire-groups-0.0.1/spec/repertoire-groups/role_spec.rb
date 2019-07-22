require 'spec_helper'
require 'factories'

describe Role do
  it "is invalid without required params" do
    @role = Role.new
    @role.should_not be_valid
  end

  it "is a valid given proper params" do
    @role = Role.new(:name => 'Guest User')
    @role.should be_valid
  end

  it "with a finder method, it creates a new role if it doesn't exist" do
    new_name_role = Role.find_or_create_new('New Role')
    new_name_role.should be_valid
  end

  it "with a finder method, it returns an existing role if it exists" do
    Role.create!({:name => 'admin'})
    current_role = Role.find_or_create_new('admin')
    current_role.should be_valid
  end
end
