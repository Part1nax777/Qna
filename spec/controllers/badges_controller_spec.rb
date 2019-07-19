require 'rails_helper'

RSpec.describe BadgesController, type: :controller do

  describe 'GET #index' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:badge) { create(:badge, :with_image, question: question, user: user) }

    before do
      login(user)
      get :index
    end

    it 'assigns badge' do
      expect(assigns(:badges)).to match_array(user.badges)
    end

    it 'render index' do
      expect(response).to render_template :index
    end
  end

end
