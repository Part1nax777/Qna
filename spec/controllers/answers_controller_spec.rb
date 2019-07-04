require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do

      it 'save answer in database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'association with user' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js

        expect(assigns(:answer).user_id).to eq(user.id)
      end

      it 'renders create template' do
        post :create, params: { answer:  attributes_for(:answer), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'not save answer in database' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }
    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload

        expect(answer.body).to eq 'new body'
      end

      it 'render update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js

        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          answer.reload
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js

        expect(response).to render_template :update
      end
    end

    context 'Another author' do
      before { login(user2) }

      it 'try update question' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload

        expect(answer.body).to_not eq 'new body'
      end

      it 'render update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js

        expect(response).to render_template :update
      end
    end
  end

  describe 'PATCH #mark_as_best' do
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:another_answer) { create(:answer, question: question, user: user) }

    context 'Author of question ticks the best answer' do
      before { login(user) }

      it 'best for answer is true' do
        patch :mark_as_best, params: { id: answer }, format: :js
        answer.reload

        expect(answer).to be_best
      end

      it 'redirect to best answer view' do
        patch :mark_as_best, params: { id: answer }, format: :js

        expect(response).to render_template :mark_as_best
      end
    end

    context 'No author of question ticks the best answer' do
      before { login(user2) }

      it 'best for answer is false' do
        patch :mark_as_best, params: { id: answer }, format: :js
        answer.reload

        expect(answer).to_not be_best
      end
    end

    context 'Unautorised user ticks the best answer' do
      it 'best for answer is false' do
        patch :mark_as_best, params: { id: answer }, format: :js
        answer.reload

        expect(answer).to_not be_best
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let!(:answer) { create(:answer, question: question, user: user1) }

    context 'Author of answer' do
      before { login(user1) }

      it 'trying delete his answer' do
        expect { delete :destroy, params: { id: answer, question_id: question }, format: :js }.to change(question.answers, :count).by(-1)
      end

      it 'render template destroy' do
        delete :destroy, params: { id: answer, question_id: question }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'No author of answer' do
      before { login(user2) }

      it 'trying delete answer' do
        expect { delete :destroy, params: { id: answer, question_id: question }, format: :js }.to_not change(Answer, :count)
      end

      it 'render template destroy' do
        delete :destroy, params: { id: answer, question_id: question }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
end
