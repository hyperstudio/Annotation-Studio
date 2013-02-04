class AddPublicationDateToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :publication_date, :date
  end
end
