require 'spec_helper'

feature 'A user visit their dashboard' do
  scenario 'they see a list of their documents' do
    user = sign_in_user
    document = create(:document, user: user)

    visit '/'
    
    expect(page).to have_content('Documents')
    expect(page).to have_content(document.title)
  end

  def sign_in_user
    password = 'foobar'
    user = create(:user, password: password)
    user.confirm!
    visit '/'
    fill_in "Email", with: user.email
    fill_in "Password", with: password
    click_on 'Sign in'
    user
  end
end
