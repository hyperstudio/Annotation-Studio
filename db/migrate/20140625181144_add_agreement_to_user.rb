class AddAgreementToUser < ActiveRecord::Migration
  def change
    add_column :users, :agreement, :boolean
  end
end
