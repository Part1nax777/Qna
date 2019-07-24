Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :votable do
    member do
      patch :vote_like
      patch :vote_dislike
      delete :revote
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, shallow: true, only: [:create, :update, :destroy], concerns: :votable do
      patch :mark_as_best, on: :member
    end
  end
  resources :files, only: [:destroy]
  resources :links, only: [:destroy]
  resources :badges, only: [:index]
end
