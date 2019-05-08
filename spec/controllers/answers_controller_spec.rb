require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create (:question) }

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

    it 'assigns new answers to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render view new' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'save answer in database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(question.answers, :count).by(1)
      end

      it 'redirect to index' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to question_answers_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'not save answer in database' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }.to_not change(Answer, :count)
      end

      it 'redirect to view new' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
        expect(response).to render_template :new
      end
    end
  end

end
