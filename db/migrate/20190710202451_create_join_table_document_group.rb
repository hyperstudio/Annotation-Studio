class CreateJoinTableDocumentGroup < ActiveRecord::Migration[5.0]
  def change
    create_join_table :documents, :groups do |t|
      # t.index [:document_id, :group_id]
      # t.index [:group_id, :document_id]
    end
  end
end
