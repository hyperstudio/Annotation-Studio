class AddIdeaSpaceToggleToGroups < ActiveRecord::Migration[5.0]
  def change
  	add_column :groups, :ideaSpaceOn, :boolean, :default => false
  end
end
