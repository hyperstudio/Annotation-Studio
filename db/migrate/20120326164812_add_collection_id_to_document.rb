class AddCollectionIdToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :collection_id, :integer

  end
end
