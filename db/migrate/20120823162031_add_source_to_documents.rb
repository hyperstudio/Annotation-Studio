class AddSourceToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :source, :string
  end
end
