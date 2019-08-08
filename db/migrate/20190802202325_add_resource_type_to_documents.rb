class AddResourceTypeToDocuments < ActiveRecord::Migration[5.0]
  def change
  	add_column :documents, :resource_type, :string, :default => "Other"
  end
end
