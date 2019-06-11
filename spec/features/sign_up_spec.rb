require 'rails_helper'

feature 'User can sign up the application', %q{
  In order to ask questions and answers,
  The user can sign up
  In the application
} do

  background { visit new_user_registration_path }

  scenario 'Unregister user trying sign up' do
    fill_in 'Email', with: 'test@user.com'
    fill_in 'Password', with: '1234567'
    fill_in 'Password confirmation', with: '1234567'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Unregister user trying sign up with errors' do
    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password can't be blank"
  end

  scenario 'Register user trying sign up' do
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end
end
