class AddConfidentialBooleanToOauthApplications < ActiveRecord::Migration[5.0]
  def change
    add_column :oauth_applications, :confidential, :boolean, default: true, null: false
  end
end
