require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:votable) }

  it 'default 0' do
    expect(Vote.new.rating).to eq(0)
  end
end
