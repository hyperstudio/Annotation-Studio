class ChangePublicationDateTypeToText < ActiveRecord::Migration[5.0]
  def up
    change_column :documents, :publication_date, :text
  end
  def down
    change_column :documents, :publication_date, :date
  end
end
