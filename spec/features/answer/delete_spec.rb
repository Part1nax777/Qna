require 'rails_helper'

feature 'User can delete answer', %q{
  The user can delete a answer,
  The answer is deleted
  Only if the user
  Is its creator
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }

  given!(:question) { create(:question, user: user) }
  given!(:question2) { create(:question, user: user2) }

  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:answer2) { create(:answer, question: question, user: user2) }

  describe 'Authenticated user', js: true do

    background { sign_in(user) }

    scenario 'trying delete his answer', js: true do
      visit question_path(question)
      click_on 'Delete answer'

      expect(page).to_not have_content answer.body
    end

    scenario 'trying delete not his answer' do
      visit question_path(question2)

      expect(page).to_not have_link 'Delete answer'
    end
  end

  describe 'Unauthenticated user', js: true do
    scenario 'trying delete answer' do
      visit question_path(question)

      expect(page).to_not have_content 'Delete answer'
    end
  end
end