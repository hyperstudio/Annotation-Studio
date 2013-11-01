class CreateImageTable < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :name
      t.string :path

      t.timestamps
    end
  end
end
