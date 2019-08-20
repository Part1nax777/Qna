class Api::V1::AnswersController < Api::V1::BaseController
  def index
    @answers = Answer.all
    render json: @answers, each_serializer: AnswersSerializer
  end

  def show
    @answer = Answer.find(params[:id])
    render json: @answer
  end
end