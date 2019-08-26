require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for guest' do
    let(:user) { nil }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:another_user) { create :user }
    let(:question) { create :question, user: user }
    let(:another_question) { create :question, user: another_user }
    let(:answer) { create :answer, user: user, question: question }
    let(:another_answer) { create :answer, user: another_user, question: another_question }
    let(:subscription) { question.subscriptions.first }
    let(:another_subscription) { another_question.subscriptions.first }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Question }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Subscription }

    it { should be_able_to :update, question }
    it { should_not be_able_to :update, another_question }
    it { should be_able_to :update, answer }
    it { should_not be_able_to :update, another_answer }

    it { should be_able_to :destroy, question }
    it { should_not be_able_to :destroy, another_question }
    it { should be_able_to :destroy, answer }
    it { should_not be_able_to :destroy, another_answer }

    it { should be_able_to :destroy, ActiveStorage::Attachment }

    it { should be_able_to :destroy, create(:link, url: 'http://ya.ru', linkable: question) }
    it { should_not be_able_to :destroy, create(:link, url: 'http://ya.ru', linkable: another_question) }
    it { should be_able_to :destroy, create(:link, url: 'http://ya.ru', linkable: answer) }
    it { should_not be_able_to :destroy, create(:link, url: 'http://ya.ru', linkable: another_answer) }

    it { should be_able_to :destroy, subscription }
    it { should_not be_able_to :destroy, another_subscription }

    it { should be_able_to :mark_as_best, answer }

    it { should be_able_to :vote_like, another_question }
    it { should_not be_able_to :vote_like, question }
    it { should be_able_to :vote_like, another_answer }
    it { should_not be_able_to :vote_like, answer }

    it { should be_able_to :vote_dislike, another_question }
    it { should_not be_able_to :vote_dislike, question }
    it { should be_able_to :vote_dislike, another_answer }
    it { should_not be_able_to :vote_dislike, answer }

    it { should be_able_to :revote, another_question }
    it { should_not be_able_to :revote, question }
    it { should be_able_to :revote, another_answer }
    it { should_not be_able_to :revote, answer }
  end
end
