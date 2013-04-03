OpenCourts::Application.routes.draw do
  root to: 'static_pages#home'
  
  match '/about',   to: 'static_pages#about'
  match '/contact', to: 'static_pages#contact'
  match '/home',    to: 'static_pages#home'
  match '/stats',   to: 'static_pages#stats'

  match '/search',               to: 'search#index'
  match '/async_search',         to: 'search#search' # TODO rename, probably both route & to
  match '/autocomplete/:entity', to: 'search#autocomplete'
  
  resources :courts do
     get :map, on: :collection
  end
  
  resources :judges
  
  resources :proceedings
  resources :hearings
  resources :decrees
  
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
