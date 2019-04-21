require 'sidekiq/web'

OpenCourts::Application.routes.draw do
  root to: 'static_pages#home'

  resources :courts, only: [:index, :show] do
    collection do
      get :suggest

      # TODO rm - unused?
      # get :map
    end
  end

  resources :judges, only: [:index, :show] do
    collection do
      get :suggest
    end

    # TODO rm - unused?
    # member do
    #   get :curriculum
    #   get :cover_letter
    # end
  end

  resources :hearings, only: [:index, :show] do
    collection do
      get :suggest
    end

    member do
      # TODO rm - unused?
      # get :resource

      delete :anonymize
    end
  end

  resources :decrees, only: [:index, :show] do
    collection do
      get :suggest
    end

    member do
      # TODO rm - unused?
      # get :resource

      get :document
    end
  end

  resources :proceedings, only: [:index, :show] do
    collection do
      get :suggest
    end
  end

  resources :selection_procedures, as: :selections, path: :selections, only: [:index, :show] do
    collection do
      get :suggest
    end

    member do
      get :declaration
      get :report
    end

    resources :selection_procedure_candidates, as: :candidates, path: :candidates, only: [] do
      member do
        # TODO rm - unused?
        # get :application
        # get :curriculum

        get :declaration

        # TODO rm - unused?
        # get :motivation_letter
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
