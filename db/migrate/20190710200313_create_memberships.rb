class CreateMemberships < ActiveRecord::Migration[5.0]
  def change
    create_table :memberships do |t|
      t.integer :group_id
      t.integer :user_id
      t.string :role, default: "member"

      t.timestamps
    end
  end
end
