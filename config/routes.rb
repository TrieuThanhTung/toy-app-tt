Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks"
 }
  get "password_resets/new"
  get "password_resets/edit"
  # get "comment/index"
  resources :microposts do
    post "/react" => "microposts#react"
    resources :comments, only: [:create] do
      post "/reply" => "comments#create"
    end
  end
  resources :users do
    get "microposts" => "users#find_by_user"
    member do
      get :following, :followers
    end
    resources :messages, only: [:index, :update, :destroy]
  end
  resources :relationships, only: [ :create, :destroy ]
  root "static_pages#home"
  get "static_pages/home"
  get "static_pages/help"
  get "static_pages/about"
  get "static_pages/contact"
  get "test" => "static_pages#test"
  get "/signup" => "users#new"
  # login routes
  get "login" => "sessions#new"
  post "login" => "sessions#create"
  delete "logout" => "sessions#destroy"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :account_activations, only: [ :edit ]
  resources :password_resets, only: [ :new, :create, :edit, :update ]
  resources :microposts, only: [ :create, :destroy ]
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
