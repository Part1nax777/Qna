require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user try edit answer', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do

    scenario 'try edit his answer' do
      sign_in(user)
      visit question_path(question)

      click_on 'Edit'
      within ".answers" do
        fill_in 'Body', with: 'modified answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'modified answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'try edit his answer with errors' do
      sign_in(user)
      visit question_path(question)

      click_on 'Edit'
      within ".answers" do
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body
        expect(page).to have_selector 'textarea'
      end
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'try edit not his answer' do
      sign_in(user2)
      visit question_path(question)

      within ".answers" do
        expect(page).to_not have_content 'Edit'
      end
    end
  end
end