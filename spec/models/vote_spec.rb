require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:votable) }

  it 'default 0' do
    expect(Vote.new.rating).to eq(0)
  end

  it 'vote is uniq for user' do
    subject.user = create(:user)
    should validate_uniqueness_of(:user_id).scoped_to([:votable_id, :votable_type])
  end
end
