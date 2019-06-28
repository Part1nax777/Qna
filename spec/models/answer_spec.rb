require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of :body }

  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:answer2) { create(:answer, question: question, user: user) }

  it 'mark best answer' do
    answer.mark_as_best

    expect(answer.best).to be_truthy
  end

  it 'one answer is best' do
    answer.mark_as_best
    answer2.mark_as_best
    answer.reload

    expect(answer.best).to_not be_truthy
  end

  it 'best answer is a first' do
    answer2.mark_as_best
    expect(Answer.first).to eq(answer2)
  end
end
