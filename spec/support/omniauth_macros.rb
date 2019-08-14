module OmniauthMacros
  def mock_auth_hash
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
        'provider' => 'github',
        'uid' => '123',
        'info' => { 'email' => 'test@test.com' })

    OmniAuth.config.mock_auth[:yandex] = OmniAuth::AuthHash.new(
        'provider' => 'yandex',
        'uid' => '123',
        'info' => { 'email' => 'test@test.com' } )
  end
end