class AddOriginToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :origin, :string
  end
end
