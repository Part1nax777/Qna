class Services::DailyDigest
  def call
    User.find_each do |user|
      DailyDigestMailer.digest(user).deliver_later
    end
  end
end