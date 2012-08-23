class Document < ActiveRecord::Base
  belongs_to :collection
  extend FriendlyId
  friendly_id :title, use: :slugged  
end
