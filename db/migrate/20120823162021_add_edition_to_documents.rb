class AddEditionToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :edition, :string
  end
end
