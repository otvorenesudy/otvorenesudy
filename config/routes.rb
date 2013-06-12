OpenCourts::Application.routes.draw do
  root to: 'static_pages#home'

  match '/about',   to: 'static_pages#about'
  match '/contact', to: 'static_pages#contact'
  match '/home',    to: 'static_pages#home'
  match '/stats',   to: 'static_pages#stats'

  match '/search',          to: 'search#search'
  match '/suggest/:entity', to: 'search#suggest'

  resources :courts do
    collection do
      get :search
      get :map
      get :suggest
    end
  end

  resources :judges do
     get :curriculum, on: :member

    collection do
      get  :search
      post :suggest
    end
  end

  resources :hearings do
    member do
      get :resource
    end

    collection do
      get  :search
      post :suggest
    end
  end

  resources :decrees do
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

    collection do
      get  :search
      get  :suggest
    end
  end

  resources :proceedings do
    collection do
      get  :search
      post :suggest
    end
  end

  match '/404', to: 'errors#show'
  match '/422', to: 'errors#show'
  match '/500', to: 'errors#show'

  mount Resque::Server.new, at: '/resque'

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
