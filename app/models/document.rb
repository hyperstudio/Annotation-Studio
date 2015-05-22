# t.string   "title"
# t.text     "text"
# t.datetime "created_at",          :null => false
# t.datetime "updated_at",          :null => false
# t.string   "author"
# t.datetime "year_published"
# t.string   "edition"
# t.string   "publisher"
# t.string   "source"
# t.string   "rights_status"
# t.string   "slug"
# t.integer  "user_id"
# t.date     "publication_date"
# t.text     "chapters"
# t.string   "state"
# t.string   "upload_file_name"
# t.string   "upload_content_type"
# t.integer  "upload_file_size"
# t.datetime "upload_updated_at"
# t.datetime "processed_at"

require "babosa" # allows cyrillic, other characters in titles (transliterates titles for URL use)

class Document < ActiveRecord::Base
  belongs_to :user, :autosave => true
  before_validation :add_title, on: :create, unless: :title?
  before_create :add_processed_at, unless: :uploaded?
  ALLOWED_CONTENT_TYPES = %w|application/msword
application/vnd.openxmlformats-officedocument.wordprocessingml.document
text/plain
application/pdf
  |

  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]

  # acts_as_taggable_on :rep_group, :courses, :semesters, :genres, :categories
  acts_as_taggable_on :rep_privacy, :rep_group

  has_attached_file :upload
  validates_attachment_content_type :upload, content_type: ALLOWED_CONTENT_TYPES

  scope :publicly, -> { where(:state => 'public').order("id asc") }

  STATES = %w{ pending draft published deleted public }

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

  def processed?
    processed_at.present?
  end

  def uploaded?
    upload_file_name.present?
  end

  def add_processed_at
    self.processed_at = Time.now
  end

  def title?
    title.present?
  end

  def add_title
    self.title = "Untitled"
  end

end
