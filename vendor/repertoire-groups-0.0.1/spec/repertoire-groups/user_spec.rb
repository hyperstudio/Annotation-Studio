require 'spec_helper'
require 'factories'

describe User do
  it "should set the 'unapproved' role on initialization if roles are empty" do
    # Okay, the default Factory methods muck up the initialization process somehow,
    # most likely 'cause I have a more complex set of associations:
    no_role_user = User.new(Factory.attributes_for(:user))
    no_role_user.has_role?(:unapproved).should be_true
  end

  it "should clear all roles and set 'unapproved' role if passed an empty array of roles" do
    no_roles_user = Factory.build(:user, :roles => [ Role.new(:name => 'test') ])
    no_roles_user.set_roles = []
    no_roles_user.roles.collect {|r| r.name}.should == ['unapproved']
  end

  it "should return true if asked if it has a role which it has" do
    has_role_user = Factory.build(:user, :roles => [ Role.new(:name => 'editor') ])
    has_role_user.has_role?(:editor).should be_true
  end

  it "should return false if asked if it has a role which does not have" do
    does_not_have_role_user = Factory.build(:user, :roles => [ Role.new(:name => 'Fake Role') ])
    does_not_have_role_user.has_role?(:some_nonexistent_role).should be_false
  end

  it "should not have duplicate roles" do
    dup_roles_user = Factory.build(:user, :roles => [])
    dup_roles_user.set_roles = ['admin', 'editor']
    lambda do
      dup_roles_user.set_roles = [ 'admin', 'editor' ]
    end.should_not change(dup_roles_user.roles, :count)
  end

  it "removes the unapproved role if other roles are set" do
    @u = Factory.build(:user)
    @u.set_roles = ['admin', 'unapproved']
    @u.save
    @u.has_role?(:unapproved).should be_false
  end
end
