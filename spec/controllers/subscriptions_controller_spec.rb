require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'return status 401 if user logout' do
      post :create, params: { question_id: question.id }, format: :js

      expect(response.status).to eq 401
    end

    context 'login user' do
      before { login(user) }

      it 'return status 200' do
        post :create, params: { question_id: question.id }, format: :js

        expect(response.status).to eq 200
      end

      it 'save subscription in db' do
        expect do
          post :create, params: { question_id: question.id }, format: :js
        end.to change(Subscription, :count).by(2)
      end

      it 'render template create' do
        post :create, params: { question_id: question.id }, format: :js

        expect(response).to render_template :create
      end
    end
  end

  describe 'POST #destroy' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:subscription) { create(:subscription, user: user, question: question) }

    it 'return status 401 if user logout' do
      delete :destroy, params: { id: subscription }, format: :js

      expect(response.status).to eq 401
    end

    context 'login user' do
      before { login(user) }

      it 'delete subscription from db' do
        expect { delete :destroy, params: { id: subscription }, format: :js }.to change(Subscription, :count).by -1
      end

      it 'renders template' do
        delete :destroy, params: { id: subscription }, format: :js

        expect(response).to render_template :destroy
      end
    end
  end
end
