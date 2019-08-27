class AddPublisherToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :publisher, :string
  end
end
