require 'sidekiq/web'

OpenCourts::Application.routes.draw do
  root to: 'static_pages#home'

  resources :courts, only: [:index, :show] do
    collection do
      get :search
      get :suggest

      get :map
    end
  end

  resources :judges, only: [:index, :show] do
    collection do
      get :search
      get :suggest
    end

    member do
      get :curriculum
      get :cover_letter

      get :indicators_suggest
    end
  end

  resources :hearings, only: [:index, :show] do
    collection do
      get :search
      get :suggest
    end

    member do
      get :resource
    end
  end

  resources :decrees, only: [:index, :show] do
    collection do
      get  :search
      get  :suggest
    end

    member do
      get :resource
      get :document
    end

    resources :decree_pages, as: :pages, path: :pages, only: [] do
      get :search, on: :collection

      member do
        get :text
        get :image
      end
    end
  end

  resources :proceedings, only: [:index, :show] do
    collection do
      get :search
      get :suggest
    end
  end

  resources :selection_procedures, only: [:show] do
    collection do
      get :search
      get :suggest
    end

    member do
      get :declaration
      get :report
    end

    resources :selection_procedure_candidates, as: :candidates, path: :candidates, only: [] do
      member do
        get :application
        get :curriculum
        get :declaration
        get :motivation_letter
      end
    end
  end

  devise_for :users

  resource :users, only: [] do
    get :subscriptions
  end

  resources :subscriptions, only: [:create, :update, :destroy]

  match '/search/collapse', to: 'search#collapse'

  match '/404', to: 'errors#show', as: :not_found_error
  match '/500', to: 'errors#show', as: :internal_server_error

  match '/:slug', via: :get, to: 'static_pages#show', as: :static_page

  mount Sidekiq::Web, at: '/sidekiq'
end
