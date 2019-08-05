class RemoveDefaultFromDocument < ActiveRecord::Migration[5.0]
  def change
  	change_column_default(:documents, :author, nil)
  	change_column_default(:documents, :publication_date, nil)
  end
end
