class Services::FindForOauth
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.find_by(email: email)
    if user
      user.create_authorization!(auth)
    else
      password = Devise.friendly_token[0, 20]
      ActiveRecord::Base.transaction do
        user = User.create!(email: email, password: password, password_confirmation: password)
        user.create_authorization!(auth)
      end
    end
    user
  end
end