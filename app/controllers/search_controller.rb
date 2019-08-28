class SearchController < ApplicationController
  skip_authorization_check

  def search
    @data = service.call(search_params)
  end

  private

  def service
    @service ||= Services::Search.new
  end

  def search_params
    params.permit([:query, :question, :answer, :comment, :user, :utf8, :commit])
  end
end
