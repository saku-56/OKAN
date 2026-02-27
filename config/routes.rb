Rails.application.routes.draw do
  devise_for :users, controllers: {
                       registrations: "users/registrations",
                       omniauth_callbacks: "users/omniauth_callbacks"
                     }
  # 薬
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

  # 病院
  resources :hospitals, only: %i[index show new create edit update destroy] do
    resources :consultation_schedules, only: %i[create update destroy]
  end

  # 通知設定の編集画面
  resource :notifications, only: [ :edit ]

  # 個別の通知設定の更新
  resources :notifications, only: [ :update ]

  # PWA
  get "manifest", to: "pwa#manifest", as: :pwa_manifest, defaults: { format: :json }
  get "service-worker", to: "pwa#service_worker", as: :pwa_service_worker, defaults: { format: :js }

  root "static_pages#top"
  get "terms_of_service", to: "static_pages#terms_of_service"
  get "privacy", to: "static_pages#privacy"
  get "home", to: "home#index"
  get "how_to_use", to: "static_pages#how_to_use"
  get "notifications", to: "notifications#required"

  get "up" => "rails/health#show", as: :rails_health_check

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
