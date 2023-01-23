Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root 'users#index'
  resources :users, only: %i[index show create]
  resources :images, only: %i[index] do
    get 'download', on: :member
    post 'compress', on: :collection
  end
end
