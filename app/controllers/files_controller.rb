class FilesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment

  def destroy
    authorize! :destroy, @attachment
    @attachment.purge if current_user.author_of?(@attachment.record)
  end

  private

  def load_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end
end