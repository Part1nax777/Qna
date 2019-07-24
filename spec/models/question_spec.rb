require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:badge).dependent(:destroy) }
  it { should belong_to(:user) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_length_of(:title).is_at_most(255) }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :badge }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it_behaves_like 'votable' do
    let(:user) { create :user }
    let(:user2) { create :user }
    let(:question) { create :question, user: user }
    let(:model) { create :question, user: user }
  end
end
