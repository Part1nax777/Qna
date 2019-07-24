require 'rails_helper'

RSpec.shared_examples 'voted' do

  describe 'PATCH #vote' do
    it 'user can like' do
      login(another_user)

      expect { (patch :vote_like, params: { id: model }, format: :json).to change(Vote, :count).by 1 }
    end

    it 'user can dislike' do
      login(another_user)

      expect { (patch :vote_dislike, params: { id: model }, format: :json).to change(Vote, :count).by 1 }
    end

    it 'unauthenticate user try vote' do
      expect { (patch :vote_like, params: { id: model }, format: :json).to_not change(Vote, :count) }
    end
  end
end
