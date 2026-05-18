require 'mission_control/jobs/engine'

OpenCourts::Application.routes.draw do
  root to: 'static_pages#home'

  resources :courts, only: %i[index show] do
    collection { get :suggest }
  end

  resources :judges, only: %i[index show] do
    collection { get :suggest }
  end

  resources :hearings, only: %i[index show] do
    collection { get :suggest }

    member { delete :anonymize }
  end

  resources :decrees, only: %i[index show] do
    collection { get :suggest }

    member { get :document }
  end

  resources :proceedings, only: %i[index show] do
    collection { get :suggest }
  end

  resources :verification, path: :verify, only: %i[index create]

  devise_for :users

  resource :users, only: [] do
    get :subscriptions
  end

  resources :subscriptions, only: %i[create update destroy] do
    collection { match 'unsubscribe/:token', action: :unsubscribe, as: :unsubscribe, via: %i[get post] }
  end

  get '/search/collapse', to: 'search#collapse'
  match '/404', to: 'errors#show', as: :not_found_error, via: :all
  match '/500', to: 'errors#show', as: :internal_server_error, via: :all
  get '/health', to: 'static_pages#health'

  authenticate :user, ->(u) { u.admin? } do
    mount MissionControl::Jobs::Engine, at: '/jobs'
  end

  match '/:slug', via: :get, to: 'static_pages#show', as: :static_page
end
