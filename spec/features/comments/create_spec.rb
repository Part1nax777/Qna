require 'rails_helper'

feature 'User can add comments', %q{
  Authorized user can add
  Comments to the answer or question
  New comment is visible to all users
  Who are on the page
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  scenario 'questions comments show on another pages', js: true do
    Capybara.using_session('user') do
      sign_in(user)
      visit(question_path(question))
    end

    Capybara.using_session('guest') do
      visit(questions_path(question))
    end

    Capybara.using_session('user') do
      within ".question-comments.comments-#{question.id}" do
        fill_in 'Comment', with: 'Comment text'
        click_on 'Create comment'
      end
    end

    Capybara.using_session('guest') do
      expect(page).to have_content 'Comment text'
    end
  end

  scenario 'answers comments show on another page', js: true do
    Capybara.using_session('user') do
      sign_in(user)
      visit(question_path(question))
    end

    Capybara.using_session('guest') do
      visit(question_path(question))
    end

    Capybara.using_session('user') do
      within ".answer-comments.comments-#{answer.id}" do
        fill_in 'Comment', with: 'Comment text'
        click_on 'Create comment'
      end
    end

    Capybara.using_session('guest') do
      expect(page).to have_content 'Comment text'
    end
  end
end