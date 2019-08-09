class RenameDocumentDescriptionAndAddUserId < ActiveRecord::Migration
  def up
    change_table :documents do |t|
      t.references :user
    end
    rename_column :documents, :description, :text
  end

  def down
    rename_column :documents, :text, :description
  end
end
