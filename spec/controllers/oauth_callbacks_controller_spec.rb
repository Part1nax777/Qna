require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'Github' do
    let(:oauth_data) { {'provider' => 'github', 'uid' => 123 } }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :github
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      it 'login user' do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
        expect(subject.current_user).to eq user
      end

      it 'redirect to root path' do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      it 'redirects to root path if user does not exist' do
        allow(User).to receive(:find_for_oauth)
        get :github
        expect(response).to redirect_to root_path
      end

      it 'does not login user' do
        allow(User).to receive(:find_for_oauth)
        get :github
        expect(subject.current_user).to_not be
      end
    end


  end
end