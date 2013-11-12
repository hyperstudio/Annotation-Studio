module UserHelper
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
