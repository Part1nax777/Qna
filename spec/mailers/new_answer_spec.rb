require "rails_helper"

RSpec.describe NewAnswerMailer, type: :mailer do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:mail) { NewAnswerMailer.new_answer(user, answer) }

  it 'render headers' do
    expect(mail.subject).to eq('New answer to your question')
    expect(mail.to).to eq([user.email])
    expect(mail.from).to eq(['from@example.com'])
  end

  it 'render body' do
    expect(mail.body.encoded).to match(question.title)
    expect(mail.body.encoded).to match(answer.body)
  end
end

