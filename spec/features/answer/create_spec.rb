require 'rails_helper'

feature 'Authenticated user can create answer', %q{
  In order to help solve the problem,
  The authenticated user can answer question
  From other users
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user_id: user.id) }

  describe 'Authenticated user' do

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'trying create answer' do
      fill_in 'Body', with: 'answer body'
      click_on 'Create answer'
      expect(page).to have_content 'You answer successfully create'
      expect(page).to have_content 'answer body'
    end

    scenario 'trying create answer with invalid data' do
      click_on 'Create answer'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user trying create answer' do
    visit question_path(question)
    fill_in 'Body', with: 'answer body'
    click_on 'Create answer'
    expect(page).to_not have_content 'answer body'
    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end
end