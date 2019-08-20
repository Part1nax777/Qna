require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json"} }

  describe 'GET /app/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorize' do
      let(:access_token) { create(:access_token) }
      let(:user) { create(:user) }
      let!(:questions) { create_list(:question, 2, user: user) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question, user: user) }

      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

      it 'return 200 status' do
        expect(response).to be_successful
      end

      it 'return list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'return all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contain user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'return list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'return all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user, files: fixture_file_upload("#{Rails.root}/spec/rails_helper.rb")) }
    let!(:comment) { create(:question_comment, commentable: question, user: user) }
    let!(:link) { create(:link, linkable: question, url: "http://ya.ru") }
    let!(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb") }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Return status'

      it_behaves_like 'Return fields' do
        let(:fields) { %w[id title body created_at updated_at] }
        let(:resource_response) { question_response }
        let(:resource_name) { question }
      end

      describe 'comments' do
        let(:comment_response) { question_response['comments'].first }

        it 'Return object of resource' do
          expect(question_response['comments'].size).to eq 1
        end

        it_behaves_like 'Return fields' do
          let(:fields) { %w[id body user_id created_at updated_at commentable_type commentable_id] }
          let(:resource_response) { comment_response }
          let(:resource_name) { comment }
        end
      end

      describe 'links' do
        let(:link_response) { question_response['links'].first }

        it 'Return object of resource' do
          expect(question_response['links'].size).to eq 1
        end

        it_behaves_like 'Return fields' do
          let(:fields) { %w[id name url created_at updated_at linkable_type linkable_id] }
          let(:resource_response) { link_response }
          let(:resource_name) { link }
        end
      end

      describe 'files' do
        it 'Return object of resource' do
          expect(question_response['files'].size).to eq 1
        end

        it 'url match file name' do
          expect(question_response['files'].first).to match '/rails_helper.rb'
        end
      end
    end
  end
end
