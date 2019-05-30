class AddSnapshotToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :snapshot, :text
  end
end
