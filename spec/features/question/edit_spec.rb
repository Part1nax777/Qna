require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:link_url) { 'http://google.com' }

  describe 'Authenticate user', js: true do

    scenario 'try edit question' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit question'

      within ".question" do
        fill_in 'Body', with: 'question changes'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to_not have_selector 'textarea'
      end
      expect(page).to have_content 'question changes'
    end

    scenario 'try edit question with mistakes' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit question'

      within ".question" do
        fill_in 'Body', with: ''
        click_on 'Save'
      end

      expect(page).to have_content question.body
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'try edit not his question' do
      sign_in(user2)
      visit question_path(question)

      expect(page).to_not have_content 'Edit'
    end

    scenario 'try add files when editing a question' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit question'
      within ".question" do
        fill_in 'Body', with: 'question body'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'
      end

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'try add links when editing question' do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit question'
      within ".question" do
        click_on 'add link'
        fill_in 'Link name', with: 'google'
        fill_in 'Url', with: link_url
        click_on 'Save'
      end

      expect(page).to have_link 'google', href: link_url
    end
  end

  describe 'Unauthenticate user', js: true do

    scenario 'try edit question' do
      sign_in(user2)
      visit question_path(question)
      expect(page).to_not have_link 'Edit'
    end
  end
end