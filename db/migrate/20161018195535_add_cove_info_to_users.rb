class AddCoveInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cove_id, :integer
    add_column :users, :full_name, :string
  end
end
