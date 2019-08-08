class User < ApplicationRecord
  attr_accessible :firstname, :lastname, :email, :password
  acts_as_role_user
  acts_as_taggable_on :rep_group
end

class TestModel < ApplicationRecord
  belongs_to :user
  attr_accessible :content, :user_id
  acts_as_taggable_on :rep_privacy, :rep_group
end

class Ability
  include CanCan::Ability
  include Repertoire::Groups::Ability

  def initialize(user)
    defaults_for user
  end
end
