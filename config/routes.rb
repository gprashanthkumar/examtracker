VanillaApplication::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.
  get 'about' => 'main#about'
  get 'help' => 'main#help'
  get 'admin' => 'admin#index'
  get 'unauthorized' => 'unauthorized#index'
  get 'demo/real-time' => 'demo#real_time'
  get 'demo/accession-search' => 'demo#accession_search'

  get 'radiologist', to: 'home#radiologist'
  get 'technologist', to: 'home#technologist'
  get 'scheregistrar', to: 'home#scheregistrar'
  get 'transcript', to: 'home#transcript'
  get 'orders', to: 'home#orders'
  get 'search', to: 'home#search'
  get 'employee_photo/:id' => 'pictures#show'
  get 'sdk', to: 'home#sdk'
  
  match ':controller(/:action(/:id(.:format)))', via: [:get, :post]
  # Vanilla of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Vanilla of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Vanilla resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Vanilla resource route with options:
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

  # Vanilla resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Vanilla resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Vanilla resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => redirect('demo/accession-search')

  # See how all your routes lay out with "rake routes"
end
