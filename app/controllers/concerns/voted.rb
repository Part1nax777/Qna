module Voted
  extend ActiveSupport::Concern

  def vote_like
    make_vote(:vote_like)
  end

  def vote_dislike
    make_vote(:vote_dislike)
  end

  def revote
    make_vote(:revote)
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_object
    @object = model_klass.find(params[:id])
  end

  def make_vote(method)
    return head :forbidden if current_user&.author_of?(set_object)

    if @object.send(method, current_user)
      render json: { resourceName: @object.class.name.downcase,
                     resourceId: @object.id,
                     resourceScore: @object.score_result }
    else
      head :forbidden
    end
  end
end
