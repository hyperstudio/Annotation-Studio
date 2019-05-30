    # t.string   "title",               limit: 255
    # t.text     "text"
    # t.datetime "created_at",                      null: false
    # t.datetime "updated_at",                      null: false
    # t.string   "author",              limit: 255
    # t.datetime "year_published"
    # t.string   "edition",             limit: 255
    # t.string   "publisher",           limit: 255
    # t.string   "source",              limit: 255
    # t.string   "rights_status",       limit: 255
    # t.string   "slug",                limit: 255
    # t.integer  "user_id"
    # t.date     "publication_date"
    # t.text     "chapters"
    # t.string   "state",               limit: 255
    # t.string   "upload_file_name",    limit: 255
    # t.string   "upload_content_type", limit: 255
    # t.integer  "upload_file_size"
    # t.datetime "upload_updated_at"
    # t.datetime "processed_at"
    # t.string   "survey_link",         limit: 255
    # t.text     "default_state"
    # t.text     "snapshot"
    # t.string   "cove_uri"

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
  friendly_id :title, use: [:slugged, :history, :finders]

  # acts_as_taggable_on :rep_group, :courses, :semesters, :genres, :categories
  acts_as_taggable_on :rep_privacy, :rep_group

  has_attached_file :upload
  validates_attachment_content_type :upload, content_type: ALLOWED_CONTENT_TYPES

  scope :publicly, -> { where(:state => 'review').order("id asc") }
  scope :active, -> { where("state != ?", 'archived').order("id asc") }

  STATES = %w{ pending draft annotatable review published archived }

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

  def normalize_friendly_id(input)
    input.to_s.to_slug.normalize(transliterations: :russian).to_s
  end

  def comes_from_cove?
    origin == 'cove' ? true : false
  end

  def processed?
    processed_at.present?
  end

  def members
    # binding.pry
    User.tagged_with(this.tag_list)
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
