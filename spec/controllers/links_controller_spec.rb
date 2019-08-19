require 'rails_helper'

RSpec.describe LinksController, type: :controller do

  let(:user) { create :user }
  let(:another_user) { create :user }
  let!(:question) { create :question, user: user }
  let!(:link) { create :link, name: 'google', url: 'http://google.com', linkable: question }

  describe "DELETE #destroy" do

    context 'Unauthenticate user' do

      it 'try delete link of question' do
        expect { delete :destroy, params: { id: link }, format: :js }.to_not change(Link, :count)
      end

      it 'response status 401' do
        delete :destroy, params: { id: link }, format: :js
        expect(response).to have_http_status(401)
      end
    end

    context 'Author of question' do
      before { login(user) }

      it 'try delete link of question' do
        expect { delete :destroy, params: { id: link }, format: :js }.to change(Link, :count).by(-1)
      end

      it 'response status 200' do
        delete :destroy, params: { id: link }, format: :js
        expect(response).to have_http_status(200)
      end
    end

    context 'Another user' do
      before { login(another_user) }

      it 'try delete link of question' do
        expect { delete :destroy, params: { id: link }, format: :js }.to_not change(Link, :count)
      end

      it 'response status 403' do
        delete :destroy, params: { id: link }, format: :js
        expect(response).to have_http_status(403)
      end
    end
  end
end