require 'spec_helper'
require 'factories'

include GroupsHelper

describe GroupsHelper do
  before(:each) do
    @tm = Factory.build(:test_model)
    @tm2 = Factory.build(:test_model)

    @tm.rep_privacy_list = ['private']
    @tm2.rep_privacy_list = ['public']
    @tm.rep_group_list = ['class1', 'class2', 'class3']
    @tm2.rep_group_list = ['class3', 'class4', 'class5']

    @tm.save
    @tm2.save
  end

  it "provides a list of unique privacy tags" do
    get_privacy_list.collect {|t| t.name}.should == ['private', 'public']
  end

  it "provides a list of unique group tags" do
    get_group_list.collect {|t| t.name}.should == ['class1', 'class2', 'class3', 'class4', 'class5']
  end
end
