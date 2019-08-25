class Services::NewAnswerNotifier
  def initialize(answer)
    @answer = answer
  end

  def send_notification
    @answer.question.subscribers.find_each(batch_size: 500) do |subscriber|
      NewAnswerMailer.new_answer(subscriber, @answer).deliver_later
    end
  end
end
