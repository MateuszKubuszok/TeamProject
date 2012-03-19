TeamProject::Application.routes.draw do
  resources :users do
    get     'invite',         on: :member
    get     'page/:page',     on: :collection, action: :index
  end

  resources :user_sessions, only: [ :new, :create, :destroy ]

  resources :invitations, only: [ :index, :destroy ] do
    get     'accept',         on: :member
    get     'to_project/:project_id/:user_id',
                              on: :collection, action: :new_to_project, as: :project
    get     'search/:project_id',
                              on: :collection, action: :search,         as: :search
  end

  resources :projects do
    resources :milestones do
      resources :tickets
    end
    resources :bugs
    get     'my',             on: :collection
    get     'my/:page',       on: :collection, action: :my
    get     'page/:page',     on: :collection, action: :index
    put     ':user_id',       on: :member,     action: :update_member,  as: :update_member
    get     ':user_id/edit',  on: :member,     action: :edit_member,    as: :edit_member
    delete  ':user_id',       on: :member,     action: :remove_member,  as: :remove_member
  end

  resources :tags, only: [:index, :show ] do
    get     'page/:page',     on: :member,     action: :show
  end

  resources :forums do
    resources :forum_threads do
      resources :responses
    end
    get     'new_for/:forum_id',
                              on: :collection, action: :new,            as: :new_for
  end

  match 'register'  => 'users#new',             as: :register
  match 'login'     => 'user_sessions#new',     as: :login
  match 'logout'    => 'user_sessions#destroy', as: :logout

  root to: 'users#index', as: :homepage

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

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
