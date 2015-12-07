class CreateAnnotationCategories < ActiveRecord::Migration
  def change
    create_table :annotation_categories do |t|
      t.string :name, :null => false
      t.string :hex
      t.string :css_classes
      t.timestamps
    end
  end
end
