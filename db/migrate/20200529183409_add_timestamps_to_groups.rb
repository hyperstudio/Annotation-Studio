class AddTimestampsToGroups < ActiveRecord::Migration[5.0]
  def change
    add_timestamps :groups, null: false, default: -> { 'NOW()' }
  end
end