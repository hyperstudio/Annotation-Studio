class AddMetadataToDocuments < ActiveRecord::Migration[5.0]
  def change
    add_column :documents, :series, :string
    add_column :documents, :location, :string
    add_column :documents, :journal_title, :string
    add_column :documents, :notes, :text
  end
end
