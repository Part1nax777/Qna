class AnswersSerializer < ActiveModel::Serializer
  attributes :id, :body, :question_id, :created_at, :updated_at
  belongs_to :user
end