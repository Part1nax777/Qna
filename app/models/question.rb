class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user

  has_many_attached :files

  validates :title, :body, presence: true
  validates :title, length: { maximum: 255 }
end
