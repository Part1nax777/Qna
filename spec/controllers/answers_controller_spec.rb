require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  before { login(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'save answer in database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(question.answers, :count).by(1)
      end

      it 'save answer in database with user association' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(user.answers, :count).by(1)
      end

      it 'redirect to view show for question' do
        post :create, params: { answer:  attributes_for(:answer), question_id: question }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'not save answer in database' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }.to_not change(question.answers, :count)
      end

      it 'not save answer in database with user association' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }.to_not change(user.answers, :count)
      end

      it 're-render to view show for question' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'Delete #destroy' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user1) }

    context 'Author of answer' do
      before { login(user1) }

      it 'trying delete his answer' do
        expect { delete :destroy, params: { id: answer, question_id: question } }.to change(question.answers, :count).by(-1)
      end

      it 'redirect to show' do
        delete :destroy, params: { id: answer, question_id: question }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'No author of answer' do
      before { login(user2) }

      it 'trying delete answer' do
        expect { delete :destroy, params: { id: answer, question_id: question } }.to_not change(question.answers, :count)
      end

      it 'redirect to show' do
        delete :destroy, params: { id: answer, question_id: question }
        expect(response).to redirect_to assigns(:question)
      end
    end
  end
end
