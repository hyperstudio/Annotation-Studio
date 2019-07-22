class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable, :rememberable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable, :confirmable,
         :timeoutable, :omniauthable, :omniauth_providers => [:wordpress_hosted]

  validates :agreement, presence: { message: "must be checked. Please check the box to confirm you have read and accepted the terms and conditions." }

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

  def admin?
    roles.pluck(:name).include? 'admin'
  end

  def self.find_for_wordpress_oauth2(auth, current)
    authed_user = User.where(email: auth.info.email.downcase).first_or_initialize do |user|
      user.firstname = auth.info.name.split(' ').first
      user.lastname = auth.info.name.split(' ').length > 1 ? auth.info.name.split(' ').last : " "
      user.agreement = true
      user.password = Devise.friendly_token[0,20]
    end
    authed_user.provider = auth.provider
    authed_user.uid = auth.uid
    if authed_user.new_record?
      authed_user.skip_confirmation!
    end
    if authed_user.save
      authed_user
    end
  end

end
