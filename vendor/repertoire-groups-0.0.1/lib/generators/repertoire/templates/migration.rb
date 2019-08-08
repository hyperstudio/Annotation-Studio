class RepertoireGroupsMigration < ActiveRecord::Migration
  def self.up
    create_table :roles, :force => true do |t|
      t.string   :name
      t.string   :description
    end

    create_table :assignments, :force => true do |t|
      t.integer       :user_id
      t.integer       :role_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :assignments
    drop_table :roles
  end
end
