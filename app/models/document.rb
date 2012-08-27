class Document < ActiveRecord::Base
  belongs_to :user, :autosave => true
  attr_accessible :title, :text, :user_id, :rep_privacy_list, :rep_group_list, :new_group
  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]
  acts_as_taggable_on :rep_privacy, :rep_group
end
