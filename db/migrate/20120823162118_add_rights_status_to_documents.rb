class AddRightsStatusToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :rights_status, :string
  end
end
