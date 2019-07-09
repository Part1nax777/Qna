require 'rails_helper'

feature 'Author can delete attached files', %q(
  The author of the question
  Can delete any files
  Attached to the question
) do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Try delete attached file to the question', js: true do
    background do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit question'
      within ".question" do
        fill_in 'Title', with: 'question title'
        fill_in 'Body', with: 'question body'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb"]
        click_on 'Save'
      end
    end

    scenario 'File is attached to question' do
      expect(page).to have_content 'rails_helper.rb'
    end

    scenario 'Author of question' do
      click_on 'Delete file'

      expect(page).to_not have_content 'rails_helper.rb'
    end

    scenario 'Unauthenticate user' do
      click_on 'Logout'
      visit question_path(question)

      expect(page).to_not have_content'Delete file'
    end

    scenario 'Another user' do
      click_on 'Logout'
      sign_in(another_user)
      visit question_path(question)

      expect(page).to_not have_content'Delete file'
    end
  end
end