class AddGroupForeignKeyToMemberships < ActiveRecord::Migration[5.0]
  def change
  	add_foreign_key :memberships, :groups
  end
end
