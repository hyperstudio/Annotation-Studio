class AddSurveyLinkToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :survey_link, :string
  end
end
