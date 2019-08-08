class AddYearPublishedToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :year_published, :datetime
  end
end
