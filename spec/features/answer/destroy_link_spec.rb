require 'rails_helper'

feature 'Author can delete link', %q{
  Author of answer can remove
  The link that he indicated
  When writing the answer
} do

  given(:user) { create :user }
  given(:another_user) { create :user }
  given(:question) { create :question, user: user }
  given(:question2) { create :question, user: another_user }
  given(:answer) { create :answer, question: question, user: user }
  given(:answer2) { create :answer, question: question2, user: another_user }
  given!(:link) { create :link, name: 'google', url: 'http://google.com', linkable: answer }
  given!(:link2) { create :link, name: 'yandex', url: 'http://yandex.ru', linkable: answer2 }

  describe 'Authenticate user', js: true do
    background do
      sign_in(user)
    end

    scenario 'Author can view delete link' do
      visit question_path(question)

      expect(page).to have_link 'Delete link'
    end

    scenario 'Author can delete link' do
      visit question_path(question)
      click_on 'Delete link'

      expect(page).to_not have_content 'google'
    end

    scenario 'Another user try delete link' do
      visit question_path(question2)

      expect(page).to have_link 'yandex'
      expect(page).to_not have_link 'Delete link'
    end
  end

  describe 'Unauthenticate user', js: true do

    scenario 'Try delete link' do
      visit question_path(question)

      expect(page).to_not have_link 'Delete link'
    end
  end
end