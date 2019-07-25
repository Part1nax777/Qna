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

  def revote(user)
    vote(user, 0)
  end

  private

  def double_voit?(user, counter)
    user_vote(user)&.rating != counter
  end

  def user_vote(user)
    votes.find_by(user: user)
  end

  def vote(user, counter)
    return false if user.author_of?(self)
    return false unless double_voit?(user, counter)

    user_vote(user)&.destroy!
    votes.create!(user: user, rating: counter)
  end
end