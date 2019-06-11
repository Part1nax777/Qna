require 'rails_helper'

feature 'User can show questions', %q{
  To solve his problem,
  User can view the question,
  And the answers to it
} do

  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'User can view question and answers' do
    visit question_path(question)
    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
    expect(page).to have_content(answer.body)
  end
end