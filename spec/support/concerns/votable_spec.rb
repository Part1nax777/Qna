require 'rails_helper'

RSpec.shared_examples 'votable' do

  it '#vote like' do
    model.vote_like(user2)
    model.reload

    expect(model.score_result).to eq(1)
  end

  it '#vote dislike' do
    model.vote_dislike(user2)
    model.reload

    expect(model.score_result).to eq(-1)
  end

  it '#score result' do
    model.vote_like(user2)
    model.vote_like(user2)
    model.vote_like(user2)
    model.vote_dislike(user2)
    model.reload

    expect(model.score_result).to eq(2)
  end
end