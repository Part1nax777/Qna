require 'rails_helper'

feature 'User can sign out from application', %q{
  By logging in the application,
  User can end his session
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    click_link 'Logout'
  end

  scenario 'Authorized user trying sign out' do
    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'Unauthorized user trying sign out' do
    expect(page).to_not have_content 'Logout'
  end
end