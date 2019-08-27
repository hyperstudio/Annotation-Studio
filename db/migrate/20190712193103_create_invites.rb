class CreateInvites < ActiveRecord::Migration[5.0]
  def change
    create_table :invites do |t|
    	t.integer :group_id
    	t.string :token
    	t.datetime :expiration_date

      t.timestamps
    end
  end
end
