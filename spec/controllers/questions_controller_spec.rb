require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }


  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, user: user) }
    before { get :index }
    before { login(user) }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end
  end

  describe 'Get #show' do
    before { get :show, params: { id: question } }
    let(:question) { create(:question, user: user) }

    it 'assign a new link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assign a new Link to :link' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end

    it 'assign a new badge to question' do
      expect(assigns(:badge)).to be_a_new(Badge)
    end
  end

  describe 'GET #edit' do
    before { login(user) }
    before { get :edit, params: { id: question } }
    let(:question) { create(:question, user: user) }

    it 'assigns the request question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'save new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'save new question in the database with user association' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(user.questions, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 'render new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    let(:question) { create(:question, user: user) }

    context 'with valid attributes' do
      before { login(user) }

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'render update view' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { login(user) }

      it 'does not change question' do
        expect do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
          question.reload
        end.to_not change(question, :body)
      end

      it 'render update view' do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with another user' do
      before { login(another_user) }

      it 'not changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        question.reload

        expect(question.title).to_not eq 'new title'
        expect(question.body).to_not eq 'new body'
      end
    end

    context 'with unauthorised user' do

      it 'not changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        question.reload

        expect(question.title).to_not eq 'new title'
        expect(question.body).to_not eq 'new body'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:question) { create(:question, user: user1) }

    context 'Author trying' do
      before { login(user1) }

      it 'delete the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirect to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'User is not author of question trying' do
      before { login(user2) }

      it 'delete the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirect to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end
  end

  it_behaves_like 'voted' do
    let(:model) { create :question, user: user }
  end

end
