class AddAuthorToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :author, :string
  end
end
