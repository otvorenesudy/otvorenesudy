OpenCourts::Application.routes.draw do
  root to: 'static_pages#home'

  match '/search/collapse', to: 'search#collapse'

  resources :courts do
    collection do
      get :search
      get :suggest

      get :map
    end
  end

  resources :judges do
    collection do
      get :search
      get :suggest
    end

    member do
      get :curriculum
      get :cover_letter
    end
  end

  resources :hearings do
    collection do
      get  :search
      get  :suggest
    end

    member do
      get :resource
    end
  end

  resources :decrees do
    collection do
      get  :search
      get  :suggest
    end

    member do
      get :resource
      get :document
    end

    resources :decree_pages, as: :pages, path: :pages do
      get :search, on: :collection

      member do
        get :text
        get :image
      end
    end
  end

  resources :proceedings do
    collection do
      get :search
      get :suggest
    end
  end

  devise_for :users

  resources :subscriptions

  resource :users do
    get :subscriptions
  end

  match '/404', to: 'errors#show', as: :not_found_error
  match '/500', to: 'errors#show', as: :internal_server_error

  mount Resque::Server.new, at: '/resque'

  match '/:slug', via: :get, to: 'static_pages#show', as: :static_page, constraints: { slug: /(about|contact|faq)/ }

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"
end
