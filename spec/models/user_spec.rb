require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:badges).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:subscribed_questions).through(:subscriptions) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:question1) { create(:question, user: user1) }
  let(:question2) { create(:question, user: user2) }

  it 'Author of question' do
    expect(user1).to be_author_of(question1)
  end

  it 'Not author of question' do
    expect(user1).to_not be_author_of(question2)
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }
    let(:service) { double('Services::FindForOauth') }

    it 'calls Services::FindForOauth' do
      expect(Services::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe '#create authorization' do
    let(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }

    it 'save new authorization in db' do
      expect { user.create_authorization!(auth) }.to change(Authorization, :count).by(1)
    end
  end

  describe '#has_subscribe?' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'true' do
      user.subscriptions.create!(question: question)

      expect(user).to be_has_subscribe(question)
    end

    it 'false' do
      expect(another_user).to_not be_has_subscribe(question)
    end
  end

  describe '#get_subscribe' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'get subscribe for question' do
      expect(user.get_subscribe(question)).to eq(user.subscriptions.first)
    end
  end
end
