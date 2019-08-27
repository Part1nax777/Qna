class Services::NewAnswerNotifier
  def initialize(answer)
    @answer = answer
  end

  def call
    @answer.question.subscribers.find_each do |subscriber|
      NewAnswerMailer.new_answer(subscriber, @answer).deliver_later
    end
  end
end
