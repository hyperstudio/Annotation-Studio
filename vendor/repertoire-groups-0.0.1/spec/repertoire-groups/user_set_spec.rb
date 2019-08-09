require 'spec_helper'
require 'factories'

describe UserSet do
  before(:each) do
    @users = []
    10.times do
      @users << Factory.build(:user)
    end
  end

  describe "Authorizations" do
    it "prevents non-admins from viewing UserSets" do
      @non_admin = Factory.build(:user, :roles => [Role.find_or_create_new('student')])
      ability = Ability.new(@non_admin)
      ability.should_not be_able_to(:manage, UserSet.new)
    end
  end

  describe "Saving Users" do
    # This is tested in Repertoire Groups too, but it was working there and not in the
    # app so I tested it here too to check and see what was up...although this succeeded too.
    # Turns out it was an issue with the incongruity between calling set_roles and
    # manipulating the roles array directly...will have to think about how to test next time.
    it "if more than one role is saved the user is not 'unapproved'" do
      @us = UserSet.new
      params = { @us.users[0].id => { 'rep_group_list' => [], 'rep_group_list_add' => [], 'roles' => ['admin', 'unapproved'] } }
      @us.users_attributes(params)
      @us.users[0].has_role?(:unapproved).should_not be(true)
    end
  end
end
