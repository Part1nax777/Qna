class DailyDigestMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_digest_mailer.digest.subject
  #
  def digest(user)
    @questions = Question.where(created_at: 1.day.ago.to_date)

    mail to: user.email, subject: 'Digest from application'
  end
end
