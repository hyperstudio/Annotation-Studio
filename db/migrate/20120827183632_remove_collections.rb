class RemoveCollections < ActiveRecord::Migration
  def up
    drop_table :collections
  end

  def down
    create_table :collections
  end
end
