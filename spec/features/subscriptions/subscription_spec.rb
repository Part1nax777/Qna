require 'rails_helper'

feature 'user can subscription to question', %q{
  Any logged-in user
  Can sibscribe from notification to the mail
  When answering his question
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'authenticate user can subscribe to question', js: true do
    sign_in another_user

    visit question_path(question)
    click_on 'Subscribe'

    expect(page).to have_content 'Unsubscribe'
    expect(page).to_not have_content 'Subscribe'
  end

  scenario 'unauthenticate user not can subscribe to question', js: true do
    visit question_path(question)

    expect(page).to_not have_content 'Subscribe'
  end
end