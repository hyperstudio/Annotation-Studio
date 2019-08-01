class DocumentsGroup < ApplicationRecord
	belongs_to :document
	belongs_to :group 
end
