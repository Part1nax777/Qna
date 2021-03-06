require 'rails_helper'

feature 'User can vote to question', %q{
  Authenticated user can vote
  Positively or negatively
  For a specific question
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:another_question) { create(:question, user: another_user) }

  describe 'Authenicated user', js: true do

    background do
      sign_in(another_user)
      visit question_path(question)
    end

    scenario 'can vote positively' do
      within ".question-#{question.id}" do
        click_on 'like'

        expect(find('.rating')).to have_content "1"
      end
    end

    scenario 'can vote negatively' do
      within ".question-#{question.id}" do
        click_on 'dislike'

        expect(find('.rating')).to have_content "-1"
      end
    end

    scenario 'not can vote like twice' do
      within ".question-#{question.id}" do
        click_on 'like'
        click_on 'like'

        expect(find('.rating')).to have_content "1"
      end
    end

    scenario 'not can vote dislike twice' do
      within ".question-#{question.id}" do
        click_on 'dislike'
        click_on 'dislike'

        expect(find('.rating')).to have_content "-1"
      end
    end

    scenario 'not can vote for his question' do
      visit question_path(another_question)

      expect(page).to_not have_content 'like'
      expect(page).to_not have_content 'dislike'
    end

    scenario 'can cancel vote for his question' do
      within ".question-#{question.id}" do
        click_on 'like'
        click_on 'cancel'

        expect(find('.rating')).to have_content "0"
      end
    end
  end

  describe 'Unauthenticate user', js: true do

    scenario 'don\'t can vote' do
      visit question_path(question)

      expect(page).to_not have_content 'like'
      expect(page).to_not have_content 'dislike'
    end
  end
end
