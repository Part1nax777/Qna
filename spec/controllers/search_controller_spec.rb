require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  describe 'GET #search' do
    before { get :search, params: { query: 'text' } }

    it 'render template' do
      expect(response).to render_template :search
    end

    it 'assigns @data' do
      expect(assigns(:data)).to be_kind_of(ThinkingSphinx::Search)
    end
  end
end
