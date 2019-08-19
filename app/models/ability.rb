# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    return guest_role unless @user
    @user.admin? ? admin_role : user_role
  end

  private

  def admin_role
    can :manage, :all
  end

  def guest_role
    can :read, :all
  end

  def user_role
    guest_role
    can :read, :all
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], user: user
    can :destroy, [Question, Answer], user: user

    can [:vote_like, :vote_dislike, :revote], [Question, Answer] do |resource|
      !user.author_of?(resource)
    end

    can :destroy, ActiveStorage::Attachment do |file|
      user.author_of?(file.record)
    end

    can :destroy, Link, linkable: { user: user }
    can :mark_as_best, Answer, question: { user: user }
  end
end
