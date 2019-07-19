require 'rails_helper'

feature 'User can add badge', %{
  When creating a question
  The user can add a badge
  For a best answer
} do

  given(:user) { create(:user) }

  scenario 'User can add badge', js: true do
    sign_in(user)
    visit new_question_path
    fill_in 'Title', with: 'question title'
    fill_in 'Body', with: 'question body'
    fill_in 'Name', with: 'badge name'
    attach_file 'Image', "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Ask'

    expect(user.questions.last.badge).to be_a(Badge)
  end
end