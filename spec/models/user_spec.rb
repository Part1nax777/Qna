require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:badges).dependent(:destroy) }

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
end
