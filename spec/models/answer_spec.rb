require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }

  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:answer2) { create(:answer, question: question, user: user) }
  let!(:answer3) { create(:answer, question: question, user: user, best: true) }

  it 'best answer is a first and only one' do
    answer2.mark_as_best

    expect(Answer.first).to_not eq(answer3)
    expect(Answer.first).to eq(answer2)
    expect(answer2).to be_best
    expect(question.answers.where(best: true).count).to eq 1
  end
end
