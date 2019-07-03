require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer1) { create(:answer, question: question, user: user) }
  let(:answer2) { create(:answer, question: question, user: user, best: true) }
  let(:answer3) { create(:answer, question: question, user: user) }

  it 'answer is mark best' do
    answer1.mark_as_best

    expect(answer1).to be_best
  end

  it 'best answer is a first and only one' do
    expect(question.answers).to eq([answer2, answer1, answer3])
    expect(question.answers.where(best: true).count).to eq 1
  end
end
