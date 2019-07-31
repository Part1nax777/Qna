class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :load_question, only: [:create]
  before_action :load_answer, only: [:update, :destroy, :mark_as_best]
  after_action :publish_answer, only: [:create]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
    @question = @answer.question
  end

  def destroy
    @question = @answer.question
    @answer.destroy if current_user.author_of?(@answer)
  end

  def mark_as_best
    @answer.mark_as_best if current_user.author_of?(@answer.question)
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast("question_#{@answer.question_id}", { answer: @answer, links: @answer.links, files: files })
  end

  def files
    @answer.files.each_with_object([]) do |file, files|
      files.push({ url: url_for(file), name: file.filename.to_s })
    end
  end
end
