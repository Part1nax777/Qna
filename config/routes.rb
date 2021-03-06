require 'sidekiq/web'

Rails.application.routes.draw do
  root to: 'questions#index'

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

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
    resources :subscriptions, shallow: true, only: [:create, :destroy]
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

      resources :questions, except: [:new, :edit] do
        resources :answers, except: [:new, :edit], shallow: true
      end
    end
  end
  get '/search', to: 'search#search'
  mount ActionCable.server => '/cable'
end
