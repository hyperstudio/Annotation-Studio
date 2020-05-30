class AddPageNumbersToDocuments < ActiveRecord::Migration[5.0]
  def change
    add_column :documents, :page_numbers, :string
  end
end
