class AddUserForeignKeyToMemberships < ActiveRecord::Migration[5.0]
  def change
  	add_foreign_key :memberships, :users
  end
end
