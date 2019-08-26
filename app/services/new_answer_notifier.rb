class Services::NewAnswerNotifier
  def initialize(answer)
    @answer = answer
  end

  def send_notification
    @answer.question.subscribers.find_each do |subscriber|
      NewAnswerMailer.new_answer(subscriber, @answer).deliver_later
    end
  end
end
