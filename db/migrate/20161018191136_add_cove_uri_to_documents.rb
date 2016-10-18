class AddCoveUriToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :cove_uri, :string
  end
end
