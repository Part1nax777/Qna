require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to able to sign in
} do

  given(:user) { create(:user) }
  background { visit new_user_session_path }

  scenario 'Registered user tries to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'notauth@test.com'
    fill_in 'Password', with: '123456'
    click_on 'Log in'
    expect(page).to have_content 'Invalid Email or password.'
  end

  scenario 'User can registered with GitHub' do
    mock_auth_hash
    click_on 'Sign in with GitHub'

    expect(page).to have_content 'Successfully authenticated from Github account.'
  end

  scenario 'User can registered with Yandex' do
    mock_auth_hash
    click_on 'Sign in with Yandex'

    expect(page).to have_content 'Successfully authenticated from Yandex account.'
  end
end

