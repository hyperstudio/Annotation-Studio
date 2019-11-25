class AddIndexToDocumentsGroups < ActiveRecord::Migration[5.0]
  def change
  	add_index :documents_groups, [:document_id, :group_id], unique: true
  end
end
