require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/questions/:id/answers' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'Authorized' do
      let!(:answers) { create_list(:answer, 2, question: question, user: user) }
      let(:answer) { answers.first }
      let(:answer_response) { json['answers'].first }
      let(:access_token) { create(:access_token) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Return status 200'

      it_behaves_like 'Return list of' do
        let(:json_resource) { json['answers'] }
      end

      it_behaves_like 'Return fields' do
        let(:fields) { %w[id body question_id created_at updated_at] }
        let(:resource_response) { answer_response }
        let(:resource_name) { answer }
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user, files: fixture_file_upload("#{Rails.root}/spec/rails_helper.rb")) }
    let!(:comment) { create(:answer_comment, commentable: answer, user: user) }
    let!(:link) { create(:link, linkable: answer, url: 'http://ya.ru') }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'Authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Return status 200'

      it_behaves_like 'Return fields' do
        let(:fields) { %w[id body question_id created_at updated_at] }
        let(:resource_response) { answer_response }
        let(:resource_name) { answer }
      end

      describe 'comments' do
        let(:comment_response) { answer_response['comments'].first }

        it_behaves_like 'Return object of resource' do
          let(:json_resource) { answer_response['comments'] }
        end

        it_behaves_like 'Return fields' do
          let(:fields) { %w[id body user_id created_at updated_at commentable_type commentable_id] }
          let(:resource_response) { comment_response }
          let(:resource_name) { comment }
        end
      end

      describe 'links' do
        let(:link_response) { answer_response['links'].first }

        it_behaves_like 'Return object of resource' do
          let(:json_resource) { answer_response['links'] }
        end

        it_behaves_like 'Return fields' do
          let(:fields) { %w[id name url created_at updated_at linkable_type linkable_id] }
          let(:resource_response) { link_response }
          let(:resource_name) { link }
        end
      end

      describe 'files' do

        it_behaves_like 'Return object of resource' do
          let(:json_resource) { answer_response['files'] }
        end

        it 'url match file name' do
          expect(answer_response['files'].first).to match '/rails_helper.rb'
        end
      end
    end
  end

  describe 'POST /api/v1/questions/:id/answers' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:access_token) { create(:access_token) }
    let(:headers) { { "ACCEPT" => 'application/json' } }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'create answer with valid attributes' do
      before { post api_path, params: { access_token: access_token.token, answer: { body: 'Body', question: question } }, headers: headers }

      it_behaves_like 'Return status 200'

      it 'add answer to db' do
        expect(Answer.count).to eq 1
      end

      it 'return fields of new object' do
        %w[id body created_at updated_at].each do |attr|
          expect(json['answer'].has_key?(attr)).to be_truthy
        end
      end
    end


    context 'create answer with invalid attributes' do
      before { post api_path, params: { access_token: access_token.token, answer: { body: nil, question: question } }, headers: headers }

      it 'Return status 422' do
        expect(response.status).to eq 422
      end

      it 'return error for body' do
        expect(json.has_key?('body')).to be_truthy
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:headers) { { "ACCEPT" => 'application/json' } }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'update answer with valid attributes' do
      before { patch api_path, params: { access_token: access_token.token, answer: { body: 'Body' } }, headers: headers }

      it_behaves_like 'Return status 200'

      it 'return fields with modify data' do
        %w[id body created_at updated_at].each do |attr|
          expect(json['answer'].has_key?(attr)).to be_truthy
        end
      end
    end

    context 'update answer with invalid attributes' do
      before { patch api_path, params: { access_token: access_token.token, answer: { body: nil } }, headers: headers }

      it 'return status 422' do
        expect(response.status).to eq 422
      end

      it 'return error for body' do
        expect(json.has_key?('body')).to be_truthy
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user, question: question) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:headers) { { "ACCEPT" => 'application/json' } }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      before { delete api_path, params: { access_token: access_token.token, answer: answer }, headers: headers }

      it_behaves_like 'Return status 200'

      it 'delete answer from db' do
        expect(Answer.count).to eq 0
      end

    end
  end
end
