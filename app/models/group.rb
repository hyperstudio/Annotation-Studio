class Group < ApplicationRecord
	has_many :memberships, :foreign_key => "group_id"
	has_many :users, through: :memberships
	accepts_nested_attributes_for :memberships

	has_and_belongs_to_many :documents

	has_many :invites
end
