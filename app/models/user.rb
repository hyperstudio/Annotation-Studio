class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :affiliation, :password_confirmation, :remember_me, :firstname, :lastname, :rep_privacy_list, :rep_group_list, :first_name_last_initial

  acts_as_role_user
  acts_as_taggable_on :rep_group, :rep_privacy
  
  # Doesn't handle missing values.
  def fullname
    "#{firstname} #{lastname}"
  end

  # Doesn't handle missing values.
  def first_name_last_initial
     "#{firstname} #{lastname.first}."
  end
     
  # Doesn't handle missing values.
  def first_initial_last_name
     "#{firstname.first}. #{lastname}"
  end
end
