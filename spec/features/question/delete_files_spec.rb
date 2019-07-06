require 'rails_helper'

feature 'Author can delete attached files', %q(
  The author of the question
  Can delete any files
  Attached to the question
) do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticate user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'try delete files attached to question' do
      click_on 'Edit question'
      within ".question" do
        fill_in 'Title', with: 'question title'
        fill_in 'Body', with: 'question body'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb"]
        click_on 'Save'
      end
      click_on "Delete file"
      expect(page).to_not have_content 'rails_helper.rb'
    end
  end

  describe 'Unauthenticate user', js: true do

    scenario 'try delete files attached to question' do
      visit question_path(question)
      expect(page).to_not have_content'Delete file'
    end
  end

  describe 'Another user', js: true do
    background do
      sign_in(another_user)
      visit question_path(question)
    end

    scenario 'try delete files attached to question' do
      expect(page).to_not have_content 'Delete file'
    end
  end
end