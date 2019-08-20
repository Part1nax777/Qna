Rails.application.routes.draw do
  use_doorkeeper
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

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :index, on: :collection
        get :me, on: :collection
      end

      resources :questions, only: [:index, :show] do
        resources :answers, only: [:index, :show], shallow: true
      end
    end
  end

  mount ActionCable.server => '/cable'
end
