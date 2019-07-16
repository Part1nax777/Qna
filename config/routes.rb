Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    resources :answers, shallow: true, only: [:create, :update, :destroy] do
      patch :mark_as_best, on: :member
    end
  end
  resources :files, only: [:destroy]
  resources :links, only: [:destroy]
end
