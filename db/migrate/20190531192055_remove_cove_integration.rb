class RemoveCoveIntegration < ActiveRecord::Migration
  def change
    remove_columns :documents, :cove_uri
    remove_columns :users, :cove_id
  end
end
