require 'rails_helper'

feature 'user can unsubscription to question', %q{
  Any logged-in user
  Can unsibscribe from notification in the mail
  When answering his question
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'authenticate user can unsubscribe to question', js: true do
    sign_in another_user

    visit question_path(question)
    click_on 'Subscribe'
    expect(page).to have_content 'Unsubscribe'

    click_on 'Unsubscribe'
    expect(page).to have_content 'Subscribe'
    expect(page).to_not have_content 'Unsubscribe'
  end

  scenario 'author can unsubscribe to question', js: :true do
    sign_in user

    visit question_path(question)
    expect(page).to have_content 'Unsubscribe'
    click_on 'Unsubscribe'

    expect(page).to have_content 'Subscribe'
    expect(page).to_not have_content 'Unsubscribe'
  end

  scenario 'unauthenticate user not can unsubscribe to question', js: true do
    visit question_path(question)

    expect(page).to_not have_content 'Unsubscribe'
  end
end

