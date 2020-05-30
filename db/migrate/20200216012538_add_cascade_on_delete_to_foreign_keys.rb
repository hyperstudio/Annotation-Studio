class AddCascadeOnDeleteToForeignKeys < ActiveRecord::Migration[5.0]
  def change
    # remove the old foreign_keys
    remove_foreign_key "groups", "users"
    remove_foreign_key "memberships", "groups"
    remove_foreign_key "memberships", "users"

    # add the new foreign_keys
    add_foreign_key "groups", "users", column: "owner_id", on_delete: :cascade
    add_foreign_key "memberships", "groups", on_delete: :cascade
    add_foreign_key "memberships", "users", on_delete: :cascade
  end
end
