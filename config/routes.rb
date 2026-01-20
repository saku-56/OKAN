Rails.application.routes.draw do
  resources :user_medicines do
    collection do
      get :autocomplete
      get :forgot_index
    end
    member do
      get :add_stock
      patch :update_stock
      patch :increment_stock
    end
  end

  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "static_pages#top"
  get "home", to: "home#index"
end
