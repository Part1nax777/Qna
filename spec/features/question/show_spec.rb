require 'rails_helper'

feature 'User can show list of questions', %q{
  To solve his problem,
  User can view a list of questions
  That other users asked
} do

  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3) }

  scenario 'Unauthenticated user can show questions' do
    visit questions_path
    questions.each do |question|
      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body)
    end
  end

  scenario 'Authenticated user can show questions' do
    sign_in(user)
    visit questions_path
    questions.each do |question|
      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body)
    end
  end
end


