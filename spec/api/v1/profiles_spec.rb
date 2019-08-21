require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json",
                    "ACCEPT" => "application/json"} }

  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorize' do
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Return status 200'

      it_behaves_like 'Return fields' do
        let(:fields) { %w[id email admin created_at updated_at] }
        let(:resource_response) { json['user'] }
        let(:resource_name) { me }
      end

      it 'does not return all public fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key attr
        end
      end
    end
  end

  describe 'Get /api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:users) { create_list(:user, 2) }
      let(:user) { users.first }
      let(:user_response) { json['users'].first }
      let(:access_token) { create :access_token }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Return status 200'

      it_behaves_like 'Return fields' do
        let(:fields) { %w[id email admin created_at updated_at] }
        let(:resource_response) { user_response }
        let(:resource_name) { user }
      end

      it_behaves_like 'Return list of' do
        let(:json_resource) { users }
      end

    end
  end
end