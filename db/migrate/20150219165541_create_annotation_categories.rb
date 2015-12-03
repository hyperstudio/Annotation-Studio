class CreateAnnotationCategories < ActiveRecord::Migration
  def change
    begin # TODO-PER: this is just here because something got out of sync.
    create_table :annotation_categories do |t|
      t.string :name, :null => false
      t.string :hex
      t.string :css_classes
      t.timestamps
    end
    rescue
      end
  end
end
