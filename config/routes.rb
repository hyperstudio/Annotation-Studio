AnnotationStudio::Application.routes.draw do

  get "api/me"

  use_doorkeeper

  get 'public/:id' => 'public_documents#show'
  get 'review/:id' => 'public_documents#show'

  devise_for :users, controllers: {registrations: 'registrations', omniauth_callbacks: 'omniauth_callbacks', 
    sessions: 'sessions'}

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)


  resources :documents do
    resources :annotations
    post :set_default_state
    post :publish
    post :publicize
    post :archive
    post :snapshot
    get :export
  end

  resources :users, only: [:show, :edit]

  authenticated :user do
    root :to => "users#show"
    get 'dashboard', to: 'users#show', as: :dashboard

    # #ajax
    # post 'dashboard', to: 'users#show'
    get 'annotations', to: 'annotations#index'
    get 'annotations/:id', to: 'annotations#show'
    get 'documents/:document_id/annotations/field/:field', to: 'annotations#field'
    # get 'groups', to: 'groups#index'
    # get 'groups/:id', to: 'groups#show'
    get 'leave' => 'groups#leave'
    
    post 'join_via_name' => "groups#join_via_name" #for joining new groups via name entry
    
    resources :groups

    get 'groups/:id/edit', to: 'groups#edit'

    #should they be post instead? 
    get 'promote', to: 'groups#promote'
    get 'remove_member', to: 'groups#remove_member'
    get 'demote', to: 'groups#demote'

    resources :invites


    
  end

  unauthenticated :user do
    devise_scope :user do
      get "/" => "devise/sessions#new"

      #invite link for unauthenticated user
      get "/dashboard" => "devise/sessions#new"
    end

  end

	get 'exception_test' => "annotations#exception_test"
  # root :to => "devise/sessions#new"

  get '/admin/autocomplete_tags',
    to: 'admin/students#autocomplete_tags',
    as: 'autocomplete_tags'

end
