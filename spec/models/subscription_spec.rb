require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should belong_to :user }
  it { should belong_to :question }

  it do
    subject.question = create(:question, user: create(:user))
    should validate_uniqueness_of(:question_id).scoped_to(:user_id)
  end
end
