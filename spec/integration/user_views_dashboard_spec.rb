require 'spec_helper'

feature 'A user visit their dashboard' do
  include UserHelper

  scenario 'they see a list of their documents' do
    user = sign_in_user
    document = create(:document, user: user)

    visit '/'
    
    expect(page).to have_content('Documents')
    expect(page).to have_content(document.title)
  end
end
