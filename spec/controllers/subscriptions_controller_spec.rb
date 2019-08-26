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
        end.to change(Subscription, :count).by(1)
      end

      it 'can not subscribe to question twice' do
        question.subscriptions.create(user: user)
        question.subscriptions.reload
        expect do
          post :create, params: { question_id: question.id}, format: :js
        end.to_not change(question.subscriptions, :count)
      end

      it 'render template create' do
        post :create, params: { question_id: question.id }, format: :js

        expect(response).to render_template :create
      end
    end
  end

  describe 'POST #destroy' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:subscription) { question.subscriptions.first.id }

    context 'user not author' do
      it 'return status 401 if user logout' do
        delete :destroy, params: { id: subscription }, format: :js

        expect(response.status).to eq 401
      end

      it 'delete subscription from db' do
        expect { delete :destroy, params: { id: subscription }, format: :js }.to_not change(question.subscriptions, :count)
      end
    end

    context 'login user' do
      before { login(user) }

      it 'delete subscription from db' do
        expect { delete :destroy, params: { id: subscription }, format: :js }.to change(question.subscriptions, :count).by -1
      end

      it 'renders template' do
        delete :destroy, params: { id: subscription }, format: :js

        expect(response).to render_template :destroy
      end
    end
  end
end
