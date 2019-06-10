require 'rails_helper'

feature 'User can create answer', %q{
  In order to help solve the problem,
  The user can answer question
  From other users
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'user trying create answer' do
    fill_in 'Body', with: 'answer body'
    click_on 'Create answer'
    expect(page).to have_content 'You answer successfully create'
    expect(page).to have_content 'answer body'
  end

  scenario 'user trying create answer with invalid data' do
    click_on 'Create answer'
    expect(page).to have_content "Body can't be blank"
  end
end