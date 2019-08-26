require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe 'digest' do
    let(:user) { create(:user) }
    let!(:questions) { create_list(:question, 2, user: user, created_at: 1.day.ago.to_date) }
    let(:mail) { DailyDigestMailer.digest(user) }

    it 'render headers' do
      expect(mail.subject).to eq('Digest from application')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it 'render body' do
      expect(mail.body.encoded).to match(questions.first.title)
      expect(mail.body.encoded).to match(questions.last.title)
    end
  end
end
