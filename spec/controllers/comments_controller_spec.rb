require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, user: user, question: question) }

  describe "POST #create" do
    before { login(user) }

    context 'comments for question' do

      context 'with valid attributes' do
        it 'save a new comment in db' do
          expect { post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js }.to change(question.comments, :count).by(1)
        end

        it 'save a new user comment in db' do
          expect { post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js }.to change(user.comments, :count).by(1)
        end

        it 'JSON in response' do
          post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js
          expect(response.headers['Content-Type']).to eq('application/json; charset=utf-8')
        end
      end

      context 'with invalid attributes' do
        it 'not save comment in db' do
          expect { post :create, params: { comment: attributes_for(:comment, :invalid), question_id: question }, format: :js }.to_not change(Comment, :count)
        end

        it 'return 422 status' do
          post :create, params: { comment: attributes_for(:comment, :invalid), question_id: question }, format: :js
          expect(response.status).to eq 422
        end
      end
    end

    context 'comments for answers' do

      context 'with valid attributes' do
        it 'save a new comment in db' do
          expect { post :create, params: { comment:  attributes_for(:comment), answer_id: answer }, format: :js }.to change(answer.comments, :count).to(1)
        end

        it 'save a new user comment in db' do
          expect { post :create, params: { comment: attributes_for(:comment), answer_id: answer }, format: :js }.to change(user.comments, :count).to(1)
        end

        it 'JSON in response' do
          post :create, params: { comment: attributes_for(:comment), answer_id: answer }, format: :js
          expect(response.headers['Content-Type']).to eq('application/json; charset=utf-8')
        end

        context 'with invalid attributes' do
          it 'not save comment in db' do
            expect { post :create, params: { comment: attributes_for(:comment, :invalid), answer_id: answer }, format: :js }.to_not change(Comment, :count)
          end

          it 'return 422 status' do
            post :create, params: { comment: attributes_for(:comment, :invalid), answer_id: answer }, format: :js
            expect(response.status).to eq 422
          end
        end
      end
    end


  end
end
