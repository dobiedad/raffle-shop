# frozen_string_literal: true

Rails.application.routes.draw do
  # ViewComponent styleguide routes (only in development and test)
  if Rails.env.local?
    get '/styleguide', to: 'styleguide#index', as: :styleguide
    get '/styleguide/*path', to: 'styleguide#previews', as: :styleguide_preview
  end

  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :users, only: [:show] do
    member do
      post :follow, to: 'follows#create'
      delete :unfollow, to: 'follows#destroy'
      get :followers
      get :following
      get :raffles
    end
  end

  resource :profile, only: [:show], controller: 'users'
  get 'feed', to: 'feed#index', as: :feed
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  root 'raffles#index'

  resources :raffles, only: %i[index show new create] do
    collection do
      get :completed
    end
    resources :raffle_tickets, only: [:create], path: 'tickets'
  end

  resource :wallet, only: [:show]
  resources :my_created_raffles, only: [:index]
  resources :my_participating_raffles, only: [:index]
  resources :my_tickets, only: [:index], controller: 'raffle_tickets'
  resources :referrals, only: [:index]
end
