class Collection < ActiveRecord::Base
  has_many :documents

  attr_accessible :rep_privacy_list, :rep_group_list
  acts_as_taggable_on :rep_privacy, :rep_group

end
