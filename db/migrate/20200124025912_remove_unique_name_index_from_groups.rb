class RemoveUniqueNameIndexFromGroups < ActiveRecord::Migration[5.0]
  def change
    remove_index :groups, :name => 'index_groups_on_name'
  end
end
