require 'rails_helper'

RSpec.describe Services::NewAnswerNotifier do
  let(:users) { create_list(:user, 3) }
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  subject { Services::NewAnswerNotifier.new(answer) }

  before do
    users.each do |user|
      answer.question.subscriptions.create(user: user)
    end

    users.push(question.user)
  end

  it 'send email to subscribers' do
    users.each { |user| expect(NewAnswerMailer).to receive(:new_answer).with(user, answer).and_call_original }
    subject.call
  end
end