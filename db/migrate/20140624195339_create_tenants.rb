class CreateTenants < ActiveRecord::Migration
  def change
    create_table :tenants do |t|
      t.string :domain
      t.string :database_name

      t.timestamps
    end

    add_index :tenants, :database_name
    add_index :tenants, :domain
  end
end
