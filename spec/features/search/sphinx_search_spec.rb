require 'sphinx_helper'

feature 'search with sphinx', %q{
  For faster search in app
  User can use search with sphinx
} do

  given!(:user) { create(:user, email: 'user@mail.com') }
  given!(:question) { create(:question, body: 'body of question', user: user) }
  given!(:answer) { create(:answer, body: 'body of answer', question: question, user: user) }
  given!(:comment) { create(:comment, body: 'body of comment', commentable: question, user: user) }

  scenario 'Search in all models', js: true, sphinx: true do

    ThinkingSphinx::Test.run do
      visit root_path
      click_on 'Find'

      expect(page).to have_content 'body of question'
      expect(page).to have_content 'body of answer'
      expect(page).to have_content 'body of comment'
      expect(page).to have_content 'user@mail.com'
    end
  end

  scenario 'Search in question model', js: true, sphinx: true do
    ThinkingSphinx::Test.run do
      visit root_path
      fill_in 'Search', with: 'question'
      check 'Question'
      click_on 'Find'

      expect(page).to have_content 'body of question'
    end
  end

  scenario 'Search in answer model', js: true, sphinx: true do
    ThinkingSphinx::Test.run do
      visit root_path
      fill_in 'Search', with: 'answer'
      check 'Answer'
      click_on 'Find'

      expect(page).to have_content 'body of answer'
    end
  end

  scenario 'Search in comment model', js: true, sphinx: true do
    ThinkingSphinx::Test.run do
      visit root_path
      fill_in 'Search', with: 'comment'
      check 'Comment'
      click_on 'Find'

      expect(page).to have_content 'body of comment'
    end
  end

  scenario 'Search in user model', js: true, sphinx: true do
    ThinkingSphinx::Test.run do
      visit root_path
      fill_in 'Search', with: 'user'
      check 'User'
      click_on 'Find'

      expect(page).to have_content 'user@mail.com'
    end
  end

  scenario 'Search unknown', js: true, sphinx: true do
    ThinkingSphinx::Test.run do
      visit root_path
      fill_in 'Search', with: 'unknown'
      click_on 'Find'

      expect(page).to_not have_content 'unknown'
      expect(page).to have_content 'No result'
    end
  end
end