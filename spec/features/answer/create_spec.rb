require 'rails_helper'

feature 'Authenticated user can create answer', %q{
  In order to help solve the problem,
  The authenticated user can answer question
  From other users
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user_id: user.id) }

  describe 'Authenticated user', js: true do

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'trying create answer' do
      fill_in 'Body', with: 'answer body'
      click_on 'Create answer'
      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'answer body'
      end
    end

    scenario 'trying create answer with invalid data' do
      click_on 'Create answer'
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'trying add files to answer' do
      fill_in 'Body', with: 'answer body'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user trying create answer' do
    visit question_path(question)
    fill_in 'Body', with: 'answer body'
    click_on 'Create answer'
    expect(page).to_not have_content 'answer body'
    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end

  describe 'multiply session', js: true do
    scenario 'the answer is added by other users' do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('another_user') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Body', with: 'Answer body'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb"]
        fill_in 'Link name', with: 'google'
        fill_in 'Url', with: 'http://google.com'
        click_on 'Create answer'

        expect(page).to have_content 'Answer body'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'google'
      end

      Capybara.using_session('another_user') do
        expect(page).to have_content 'Answer body'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'google'
      end
    end
  end
end