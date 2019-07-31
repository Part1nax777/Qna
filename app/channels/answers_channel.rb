class AnswersChannel < ApplicationCable::Channel
  def following(data)
    stream_from "question_#{data['question_id']}"
  end
end
