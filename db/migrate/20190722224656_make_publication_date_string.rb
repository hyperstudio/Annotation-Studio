class MakePublicationDateString < ActiveRecord::Migration[5.0]
  def change
  	change_column :documents, :publication_date, :string
  end
end
