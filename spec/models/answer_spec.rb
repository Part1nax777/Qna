require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should have_many(:links) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }


  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer1) { create(:answer, question: question, user: user) }
  let(:answer2) { create(:answer, question: question, user: user, best: true) }
  let(:answer3) { create(:answer, question: question, user: user) }
  let(:answer4) { create(:answer, question: question, user: user2) }
  let(:badge) { create(:badge, question: question, user: user2) }

  it 'answer is mark best' do
    answer3.mark_as_best

    expect(answer3).to be_best
  end

  it 'answer is mark best only one' do
    answer3.mark_as_best

    expect(question.answers.where(best: true).count).to eq 1
  end

  it 'best answer is a first and only one' do
    expect(question.answers).to eq([answer2, answer1, answer3])
  end

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it 'add badge for the best answer' do
    answer4.mark_as_best
    expect(answer4.user).to eq(badge.user)
  end

  describe 'answer mailer' do
    let(:user) { create(:user) }
    let(:question) { build(:question, user: user) }

    it 'send answer to autor of question' do
      expect(NewAnswerMailer).to receive(:new_answer).and_call_original
      create(:answer, question: question, user: user)
    end
  end
end
