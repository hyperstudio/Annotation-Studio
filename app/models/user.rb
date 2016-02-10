class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable, :rememberable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable, :confirmable, :timeoutable

  validates :agreement, presence: true

  extend FriendlyId
  friendly_id :username, use: [:slugged, :history]

  acts_as_role_user
  acts_as_taggable_on :rep_group, :rep_privacy, :rep_subgroup

  has_many :documents

  # Doesn't handle missing values.
  def fullname
    "#{firstname} #{lastname}"
  end

  def username
    "#{firstname.downcase}#{lastname.first.downcase}"
  end

  # Doesn't handle missing values.
  def first_name_last_initial
     "#{firstname} #{lastname.first}."
  end

  # Doesn't handle missing values.
  def first_initial_last_name
     "#{firstname.first}. #{lastname}"
  end

  def has_document_permissions?(document)
    self.has_role?(:admin) || self == document.user
  end

  def self.all_tags()
    tags = User.rep_group_counts.map{|t| t.name}
    return tags.sort!
  end
end
