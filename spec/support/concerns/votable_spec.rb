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
    model.vote_like(user3)
    model.reload

    expect(model.score_result).to eq(2)
  end

  it 'user can vote like only one' do
    model.vote_like(user2)
    model.vote_like(user2)
    model.reload

    expect(model.score_result).to eq(1)
  end

  it 'user can vote dislike only one' do
    model.vote_dislike(user2)
    model.vote_dislike(user2)
    model.reload

    expect(model.score_result).to eq(-1)
  end

  it 'author don\'t can vote like' do
    model.vote_like(user)
    model.reload

    expect(model.score_result).to_not eq(1)
  end

  it 'author don\'t can vote dislike' do
    model.vote_dislike(user)
    model.reload

    expect(model.score_result).to_not eq(-1)
  end
end