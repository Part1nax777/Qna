require 'rails_helper'

feature 'User can delete question', %q{
  The user can delete a question,
  The question is deleted
  Only if the user
  Is its creator
} do

  given(:user1) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, user: user1) }

  scenario 'Creator trying delete his question' do
    sign_in(user1)
    visit question_path(question)
    click_on 'Delete question'

    expect(page).to_not have_content question.title
    expect(page).to_not have_content question.body
  end

  scenario 'User trying delete not his question' do
    sign_in(user2)
    visit question_path(question)

    expect(page).to_not have_content 'Delete question'
  end

  scenario 'Unauthenticated user trying delete question' do
    visit question_path(question)

    expect(page).to_not have_content 'Delete question'
  end
end