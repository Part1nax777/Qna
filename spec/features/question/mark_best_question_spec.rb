require 'rails_helper'

feature 'User can mark best answer', %q{
  The author of a question
  Can choose the best answer
  Of other users for his question
} do

  given!(:user) { create(:user) }
  given!(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:another_question) { create(:question, user: another_user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:answer2) { create(:answer, question: question, user: user) }


  describe 'Authenticated user', js: true do

    background do
      sign_in(user)
    end

    scenario 'Author of question can mark best answer' do
      visit question_path(question)

      first('.mark-as-best').click
      first('.mark-as-best', {}, &:visible?).click

      expect(page).to have_css('.best', count: 1)
    end

    scenario 'Author of question can mark another best question' do
      answer.best = true
      visit question_path(question)

      first('.mark-as-best').click

      expect(page).to have_css('.best', count: 1)
    end

    scenario 'No author not can mark best question' do

      visit question_path(another_question)

      expect(page).to_not have_link 'Best answer'
    end
  end

  describe 'Unauthenticate user', js: true do

    background do
      sign_in(another_user)
    end

    scenario 'try choose best answer' do
      visit question_path(question)

      expect(page).to_not have_link 'Best answer'
    end
  end
end