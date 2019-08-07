class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: :create
  after_action :publish_comment, only: [:create]

  def create
    @comment = @commentable.comments.new(comments_params)
    @comment.user = current_user
    if @comment.save
      render json: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  private

  def set_commentable
    data = resource_params
    @commentable = data[:klass].find(data[:id])
  end

  def resource_params
    klass = params['question_id'].nil? ? Answer : Question
    id = params["#{klass.to_s.downcase}_id"]
    { id: id, klass: klass }
  end

  def comments_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?
    data = resource_params
    question_id = data[:klass] == Question ? data[:id] : Answer.find(data[:id]).question_id
    ActionCable.server.broadcast("questions/#{question_id}/comments", comment: @comment)
  end
end
