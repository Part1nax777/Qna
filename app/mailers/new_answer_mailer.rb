class NewAnswerMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.new_answer_mailer.digest.subject
  #
  def new_answer(answer)
    @answer = answer

    mail to: answer.question.user.email, subject: "New answer to your question"
  end
end
