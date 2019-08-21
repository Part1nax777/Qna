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

      it_behaves_like 'Return status'

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

      it_behaves_like 'Return status'

      it_behaves_like 'Return fields' do
        let(:fields) { %w[id body question_id created_at updated_at] }
        let(:resource_response) { answer_response }
        let(:resource_name) { answer }
      end

      describe 'comments' do
        let(:comment_response) { answer_response['comments'].first }

        it 'Return object of resource' do
          expect(answer_response['comments'].size).to eq 1
        end

        it_behaves_like 'Return fields' do
          let(:fields) { %w[id body user_id created_at updated_at commentable_type commentable_id] }
          let(:resource_response) { comment_response }
          let(:resource_name) { comment }
        end
      end

      describe 'links' do
        let(:link_response) { answer_response['links'].first }

        it 'Return object of resource' do
          expect(answer_response['links'].size).to eq 1
        end

        it_behaves_like 'Return fields' do
          let(:fields) { %w[id name url created_at updated_at linkable_type linkable_id] }
          let(:resource_response) { link_response }
          let(:resource_name) { link }
        end
      end

      describe 'files' do
        it 'Return object of resource' do
          expect(answer_response['files'].size).to eq 1
        end

        it 'url match file name' do
          expect(answer_response['files'].first).to match '/rails_helper.rb'
        end
      end
    end
  end
end
