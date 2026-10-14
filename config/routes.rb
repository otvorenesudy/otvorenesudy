# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  root 'static_pages#home'

  resources :courts, only: %i[index show] do
    get :suggest, on: :collection
  end

  resources :judges, only: %i[index show] do
    get :suggest, on: :collection
  end

  resources :hearings, only: %i[index show] do
    get :suggest, on: :collection
    delete :anonymize, on: :member
  end

  resources :decrees, only: %i[index show] do
    collection do
      get :suggest
      get :uoo
    end

    get :document, on: :member
  end

  resources :proceedings, only: %i[index show] do
    get :suggest, on: :collection
  end

  # Selection procedures have been hidden since October 2025. Their controllers and views are ported and kept until
  # the pages come back.
  #
  # resources :selection_procedures, as: :selections, path: :selections, only: %i[index show] do
  #   get :suggest, on: :collection
  #
  #   member do
  #     get :declaration
  #     get :report
  #   end
  #
  #   resources :selection_procedure_candidates, as: :candidates, path: :candidates, only: [] do
  #     get :declaration, on: :member
  #   end
  # end

  devise_for :users

  resource :users, only: [] do
    get :subscriptions
  end

  resources :subscriptions, only: %i[create update destroy] do
    match 'unsubscribe/:token', action: :unsubscribe, as: :unsubscribe, on: :collection, via: %i[get post]
  end

  post 'search/collapse', to: 'search#collapse', as: :collapse_facet

  get 'health', to: 'static_pages#health'

  # config.exceptions_app renders error pages through here.
  match ':status', to: 'errors#show', constraints: { status: /\d{3}/ }, via: :all, as: :error

  mount Sidekiq::Web, at: '/sidekiq'
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  get ':slug', to: 'static_pages#show', as: :static_page
end
