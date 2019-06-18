require 'rails_helper'

feature 'User can show questions', %q{
  To solve his problem,
  User can view the question,
  And the answers to it
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 3, question: question, user: user) }

  scenario 'User can view question and answers' do
    visit question_path(question)

    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
