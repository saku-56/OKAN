Rails.application.routes.draw do
  resources :user_medicines, only: %i[index show new create destroy] do
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

  resources :hospitals, only: %i[index show new create edit update destroy] do
    resources :consultation_schedules, only: %i[create update destroy]
  end

  # 通知設定の編集画面
  resource :notifications, only: [ :edit ]

  # 個別の通知設定の更新
  resources :notifications, only: [ :update ]

  devise_for :users, controllers: {
                       registrations: "users/registrations",
                       omniauth_callbacks: "users/omniauth_callbacks"
                     }

  get "up" => "rails/health#show", as: :rails_health_check
  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "static_pages#top"
  get "terms_of_service", to: "static_pages#terms_of_service"
  get "privacy", to: "static_pages#privacy"
  get "home", to: "home#index"
  get "line_connections", to: "line_connections#required"
end
