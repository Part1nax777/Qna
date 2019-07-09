require 'rails_helper'

feature 'Author can delete attached files', %q{
  The author of the answer
  Can delete any files
  Attached to the answer
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Try delete attached file to the answer', js: true do
    background do
      sign_in(user)
      visit question_path(question)
      fill_in 'Body', with: 'answer body'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb"]
      click_on 'Create answer'
    end

    scenario 'File is attached to answer' do
      expect(page).to have_content 'rails_helper.rb'
    end

    scenario 'Author of answer' do
      click_on 'Delete file'

      expect(page).to_not have_content 'rails_helper.rb'
    end

    scenario 'Unauthenticate user' do
      click_on 'Logout'
      visit question_path(question)

      expect(page).to_not have_link 'Delete file'
    end

    scenario 'Another user' do
      click_on 'Logout'
      sign_in(another_user)
      visit question_path(question)

      expect(page).to_not have_link 'Delete file'
    end
  end
end