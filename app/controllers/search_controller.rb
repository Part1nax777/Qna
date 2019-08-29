class SearchController < ApplicationController
  skip_authorization_check

  def search
    @data = Services::Search.new.call(search_params)
  end

  private

  def search_params
    params.permit([:query, :question, :answer, :comment, :user, :utf8, :commit])
  end
end
