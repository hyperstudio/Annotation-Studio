require "babosa" # allows cyrillic, other characters in titles (transliterates titles for URL use)

class Document < ActiveRecord::Base
  belongs_to :user, :autosave => true
  attr_accessible :title, :state, :chapters, :text, :user_id, :rep_privacy_list, :rep_group_list, :new_group, :author, :edition, :publisher, :publication_date, :source, :rights_status
  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]
  # acts_as_taggable_on :rep_group, :courses, :semesters, :genres, :categories
  acts_as_taggable_on :rep_privacy, :rep_group

  STATES = %w{ draft published deleted }

  STATES.each do |state|
    define_method("#{state}?") do
      self.state == state
    end

    define_method("#{state}!") do
      self.update_attribute(:state, state)
    end
  end

  def new_group=(group_name)
    rep_group_list << group_name unless group_name.nil? || group_name.empty?
  end

  # def normalize_friendly_id(text)
  #   text.to_slug.normalize! :transliterations => :russian
  # end

  def normalize_friendly_id(input)
    input.to_s.to_slug.normalize(transliterations: :russian).to_s
  end

end
