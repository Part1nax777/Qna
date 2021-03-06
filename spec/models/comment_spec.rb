require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to :user }
  it { should belong_to(:commentable).touch }

  it { should validate_presence_of :body }

  it_behaves_like 'sphinxable', Comment
end