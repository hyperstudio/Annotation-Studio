class RemoveCollectionIdFromDocuments < ActiveRecord::Migration
  def up
    remove_column :documents, :collection_id
  end

  def down
    add_column :documents, :collection_id, :integer
  end
end
