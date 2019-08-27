class AddProcessedAtToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :processed_at, :datetime
  end
end
