require 'sidekiq/web'

OpenCourts::Application.routes.draw do
  root to: 'static_pages#home'

  resources :courts, only: %i[index show] do
    collection do
      get :suggest

      # TODO rm - unused?
      # get :map
    end
  end

  resources :judges, only: %i[index show] do
    collection { get :suggest }

    # TODO rm - unused?
    # member do
    #   get :curriculum
    #   get :cover_letter
    # end
  end

  resources :hearings, only: %i[index show] do
    collection { get :suggest }

    member do
      # TODO rm - unused?
      # get :resource

      delete :anonymize
    end
  end

  resources :decrees, only: %i[index show] do
    collection { get :suggest }

    member { get :document }
  end

  resources :proceedings, only: %i[index show] do
    collection { get :suggest }
  end

=begin
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
=end

  resources :verification, path: :verify, only: %i[index create]

  devise_for :users

  resource :users, only: [] do
    get :subscriptions
  end

  resources :subscriptions, only: %i[create update destroy]

  match '/search/collapse', to: 'search#collapse'
  match '/404', to: 'errors#show', as: :not_found_error
  match '/500', to: 'errors#show', as: :internal_server_error
  match '/health', to: 'static_pages#health'

  mount Sidekiq::Web, at: '/sidekiq'

  match '/:slug', via: :get, to: 'static_pages#show', as: :static_page
end
