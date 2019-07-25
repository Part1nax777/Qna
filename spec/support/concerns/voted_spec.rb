require 'rails_helper'

RSpec.shared_examples 'voted' do
  let(:user) { create :user }
  let(:another_user) { create :user }

  describe 'PATCH #vote' do
    it 'user can like' do
      login(another_user)

      expect do
        patch :vote_like, params: { id: model }, format: :json
        model.reload
      end.to change(model.votes, :count).by(1)
    end

    it 'user can dislike' do
      login(another_user)

      expect do
        patch :vote_dislike, params: { id: model }, format: :json
        model.reload
      end.to change(model.votes, :count).by(1)
    end

    it 'unauthenticate user try vote' do
      expect do
        patch :vote_like, params: { id: model }, format: :json
      end.to_not change(model.votes, :count)
    end

    it 'user try vote like for his resource' do
      login(user)
      patch :vote_like, params: { id: model }, format: :json

      expect(response).to have_http_status :forbidden
    end

    it 'user try vote dislike for his resource' do
      login(user)
      patch :vote_dislike, params: { id: model }, format: :json

      expect(response).to have_http_status :forbidden
    end

    it 'user try cancel vote for his resource' do
      login(another_user)

      patch :vote_like, params: { id: model }, format: :json
      delete :revote, params: { id: model }, format: :json

      expect(model.score_result).to eq 0
    end
  end
end
