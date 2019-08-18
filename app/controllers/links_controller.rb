class LinksController < ApplicationController
  before_action :authenticate_user!
  before_action :find_link, only: [:destroy]

  authorize_resource

  def destroy
    if current_user.author_of?(@link.linkable)
      @link.destroy
    else
      head 403
    end
  end

  private

  def find_link
    @link = Link.find(params[:id])
  end
end