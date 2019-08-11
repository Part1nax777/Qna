Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  root to: 'questions#index'

  concern :votable do
    member do
      patch :vote_like
      patch :vote_dislike
      delete :revote
    end
  end

  concern :commentable do
      resources :comments
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, shallow: true, only: [:create, :update, :destroy], concerns: [:votable, :commentable] do
      patch :mark_as_best, on: :member
    end
  end
  resources :files, only: [:destroy]
  resources :links, only: [:destroy]
  resources :badges, only: [:index]

  mount ActionCable.server => '/cable'
end
