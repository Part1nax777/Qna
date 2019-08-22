class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :load_question, only: [:show, :update, :destroy]

  authorize_resource

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    @question = Question.find(params[:id])
    render json: @question
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_resource_owner

    if @question.save
      render json: @question, status: :created
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  def update
    if @question.update(question_params)
      render json: @question, status: :ok
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @question.destroy
      head :ok
    else
      head :forbidden
    end
  end

  private

  def question_params
    params.require(:question).permit(:body, :title)
  end

  def load_question
    @question = Question.find(params[:id])
  end
end