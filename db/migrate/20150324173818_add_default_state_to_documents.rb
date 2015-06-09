class AddDefaultStateToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :default_state, :text
  end
end
