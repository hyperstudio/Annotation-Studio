class AddS3Params < ActiveRecord::Migration
  def change
    add_column :documents, :filename, :string
    add_column :documents, :bucket, :string
    add_column :documents, :nickname, :string
  end
end
