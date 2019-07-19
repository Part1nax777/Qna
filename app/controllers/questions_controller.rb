class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new
  end

  def new
    @question = current_user.questions.new
    @question.links.new
    @badge = @question.build_badge
  end

  def edit; end

  def create
    @question = current_user.questions.new(questions_params)

    if @question.save
      redirect_to @question, notice: 'You question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(questions_params) if current_user.author_of?(@question)
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy if current_user.author_of?(@question)
    redirect_to questions_path
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def questions_params
    params.require(:question).permit(:title, :body,
                                     files: [],
                                     links_attributes: [:name, :url],
                                     badge_attributes: [:name, :image])
  end
end
