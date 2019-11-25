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
    # t.text     "publication_date"
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

class Document < ApplicationRecord
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

  #new groups table structure:
  has_and_belongs_to_many :groups

  has_attached_file :upload
  validates_attachment_content_type :upload, content_type: ALLOWED_CONTENT_TYPES

  # #make title mandatory.
  # validates_presence_of :title --> not working?? document is still being created. problem possibly with
  #respond to do: format html

  scope :publicly, -> { where(:state => 'public').order("id desc") }
  scope :active, -> { where("state != ?", 'deleted').order("id desc") }

  STATES = %w{ pending draft published archived public }

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
