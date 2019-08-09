class AddChaptersToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :chapters, :text
  end
end
