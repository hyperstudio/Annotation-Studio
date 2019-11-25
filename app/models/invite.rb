class Invite < ApplicationRecord

	belongs_to :group

	before_create :generate_token

	def generate_token
		self.token = Digest::SHA1.hexdigest([self.group_id, Time.now, rand].join)
	end
end
