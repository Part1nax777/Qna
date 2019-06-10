require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create (:question) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'save answer in database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(question.answers, :count).by(1)
      end

      it 'redirect to view show for question' do
        post :create, params: { answer:  attributes_for(:answer), question_id: question }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'not save answer in database' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }.to_not change(Answer, :count)
      end

      it 're-render to view show for question' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
        expect(response).to render_template 'questions/show'
      end
    end
  end

end
