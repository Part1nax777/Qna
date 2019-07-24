module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def score_result
    votes.sum(:rating)
  end

  def vote_like(user)
    vote(user, 1)
  end

  def vote_dislike(user)
    vote(user, -1)
  end

  private

  def vote(user, counter)
    votes.create(user: user, rating: counter)
  end
end