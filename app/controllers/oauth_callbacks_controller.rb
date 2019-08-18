class OauthCallbacksController < Devise::OmniauthCallbacksController

  skip_authorization_check

  def github
    oauth('Github')
  end

  def yandex
    oauth('Yandex')
  end

  private

  def oauth(client)
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: client) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end