class Document < ActiveRecord::Base
  belongs_to :user, :autosave => true
  attr_accessible :title, :text, :user_id, :rep_privacy_list, :rep_group_list, :new_group, :author, :edition, :publisher, :source, :rights_status
  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]
  acts_as_taggable_on :rep_group, :courses, :semesters, :genres, :categories

  def new_group=(group_name)
    rep_group_list << group_name unless group_name.nil? || group_name.empty?
  end

end
