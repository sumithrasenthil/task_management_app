require 'sidekiq/web'
Rails.application.routes.draw do
  resources :tasks
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root to: 'home#index'
  
    mount Sidekiq::Web => '/sidekiq'
end
