require 'spec_helper'
require 'factories'
require 'cancan/matchers'

describe Repertoire::Groups::Ability do

  before(:each) do
    # (See user_spec.rb for explanation of why I'm doing it this way:)
    @user0 = User.new(Factory.attributes_for(:user))
    @user1 = User.new(Factory.attributes_for(:user))
    @user2 = User.new(Factory.attributes_for(:user))
    @user3 = User.new(Factory.attributes_for(:user))

    [@user1, @user2, @user3].each { |u| u.set_roles = ['test_role']; u.save }

    @default_tm = Factory.create(:test_model, :user => @user1)
    @public_tm  = Factory.create(:test_model, :user => @user1)
    @group_tm   = Factory.create(:test_model, :user => @user1)
    @private_tm = Factory.create(:test_model, :user => @user1)

    @public_tm.rep_privacy_list = ['public']
    @group_tm.rep_group_list = ['myGroup']
    @private_tm.rep_privacy_list = ['private']

    # Add these two to the same Group:
    @user1.rep_group_list = ['myGroup']
    @user3.rep_group_list = ['myGroup']
  end

  it "prevents unapproved Users from managing Models by default" do
    ability = Ability.new(@user0)
    ability.should_not be_able_to(:manage, TestModel)
  end

  it "prevents Models from being managed by other users by default" do
    ability = Ability.new(@user2)
    ability.should_not be_able_to(:manage, @default_tm)
  end

  it "allows Models marked as public to be read by anyone." do
    ability = Ability.new(@user2)
    ability.should be_able_to(:read, @public_tm)
  end

  it "allows Models with the same group as the User to be read by that User" do
    ability = Ability.new(@user3)
    ability.should be_able_to(:read, @group_tm)
  end

  it "prevents 'private' Models from being managed at all by other Users (even those in the same group)" do
    ability = Ability.new(@user3)
    ability.should_not be_able_to(:manage, @private_tm)
  end
end
