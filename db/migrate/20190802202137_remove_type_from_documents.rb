class RemoveTypeFromDocuments < ActiveRecord::Migration[5.0]
  def change
  	remove_column :documents, :type
  end
end
