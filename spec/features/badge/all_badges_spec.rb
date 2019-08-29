require 'rails_helper'

feature 'user can show badges', %q{
  User can view the badges
  he received, given the best answers
} do

  given(:user) { create :user }
  given!(:question) { create :question, user: user }
  given!(:answer) { create :answer, question: question, user: user }
  given!(:badge) { create :badge, :with_image, question: question }

  scenario 'User can look his badges', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Best answer'

    sleep 2

    visit badges_path

    expect(page).to have_content question.title
    expect(page).to have_content badge.name
    expect(page).to have_selector '.badges'
  end
end