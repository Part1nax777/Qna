require 'rails_helper'

RSpec.describe FilesController, type: :controller do

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let!(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb") }

  describe 'DELETE #destroy' do

    context 'Author of question' do
      let!(:question) { create(:question, user: user, files: file) }
      before { login(user) }

      it 'try delete file of' do
        expect { delete :destroy, params: { id: question.files.first}, format: :js }.to change(ActiveStorage::Attachment, :count).by(-1)
      end

      it 'render template destroy' do
        delete :destroy, params: { id: question.files.first}, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Unauthenticate user' do
      let!(:question) { create(:question, user: user, files: file) }

      it 'try delete file' do
        expect { delete :destroy, params: { id: question.files.first}, format: :js }.to_not change(ActiveStorage::Attachment, :count)
      end

      it 'response status 401' do
        delete :destroy, params: { id: question.files.first}, format: :js
        expect(response).to have_http_status 401
      end
    end

    context 'Another author of question' do
      let!(:question) { create(:question, user: user, files: file) }
      before { login(another_user) }

      it 'try delete file' do
        expect { delete :destroy, params: { id: question.files.first}, format: :js }.to_not change(ActiveStorage::Attachment, :count)
      end

      it 'render template destroy ' do
        delete :destroy, params: { id: question.files.first}, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
end