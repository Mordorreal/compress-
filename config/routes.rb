Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :users, only: %i[index show create]
  resources :images, only: %i[index] do
    get 'download', on: :member
    post 'compress', on: :collection
  end

  # Sidekiq Web UI
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
