class RemoveMandatoryFieldsFromDocument < ActiveRecord::Migration[5.0]
  def change
  	change_column :documents, :title, :string, :null => true
  	change_column :documents, :author, :string, :null => true
  	change_column :documents, :publication_date, :string, :null => true

  end
end
