require 'sidekiq/web'

OpenCourts::Application.routes.draw do
  root to: 'static_pages#home'

  resources :courts, only: [:index, :show] do
    collection do
      get :collapse
      get :suggest
    end
  end

  resources :judges, only: [:index, :show] do
    collection do
      get :collapse
      get :suggest
    end
  end

  resources :hearings, only: [:index, :show] do
    collection do
      get :collapse
      get :suggest
    end

    member do
      delete :anonymize
    end
  end

  resources :decrees, only: [:index, :show] do
    collection do
      get :collapse
      get :suggest
    end
  end

  resources :proceedings, only: [:index, :show] do
    collection do
      get :collapse
      get :suggest
    end
  end

  resources :selection_procedures, as: :selections, path: :selections, only: [:index, :show] do
    collection do
      get :collapse
      get :suggest
    end

    # TODO do we have declarations / reports available in production?
    member do
      get :declaration
      get :report
    end

    resources :selection_procedure_candidates, as: :candidates, path: :candidates, only: [] do
      member do
        get :declaration
      end
    end
  end

  devise_for :users

  resource :users, only: [] do
    get :subscriptions
  end

  resources :subscriptions, only: [:create, :update, :destroy]

  match '/404', to: 'errors#show', as: :not_found_error
  match '/500', to: 'errors#show', as: :internal_server_error

  match '/:slug', via: :get, to: 'static_pages#show', as: :static_page

  mount Sidekiq::Web, at: '/sidekiq'
end
