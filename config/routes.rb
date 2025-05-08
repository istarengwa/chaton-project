Rails.application.routes.draw do
  post "checkout", to: "orders#create_checkout", as: :checkout
  get "orders/success", to: "orders#success"
  get "orders/cancel", to: "orders#cancel"
  get "/profil", to: "users#profile", as: :user_profile

  resources :order_items
  resources :orders, only: [:create, :index, :show]
  get "carts/show"
  resources :cart_items
  devise_for :users
  resources :items
  resource :cart, only: [:show]


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "items#index"
end
