class AddOwnerToGroups < ActiveRecord::Migration[5.0]
  def change
    add_reference :groups, :owner, foreign_key: { to_table: :users }
  end
end
