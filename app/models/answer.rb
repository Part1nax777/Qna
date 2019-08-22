class Answer < ApplicationRecord
  include Votable
  include Commentable

  default_scope { order(best: :desc) }

  belongs_to :question
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true

  after_create :send_mail_to_author

  def mark_as_best
    transaction do
      question.answers.where(best: true).update_all(best: false)
      update!(best: true)
      question.badge&.update!(user: user)
    end
  end

  private

  def send_mail_to_author
    NewAnswerMailer.new_answer(self).deliver_later
  end
end
