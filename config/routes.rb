AnnotationStudio::Application.routes.draw do


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
    
    post 'annotations', to: 'annotations#search'    
    get 'annotations', to: 'annotations#index'    
    get 'annotations/:id', to: 'annotations#show'
    get 'documents/:document_id/annotations/field/:field', to: 'annotations#field'
    get 'leave' => 'groups#leave'
    
    #post 'join_via_name' => "groups#join_via_name" #for joining new groups via name entry
    
    resources :groups

    #should they be post instead? 
    get 'remove_member', to: 'groups#remove_member'
    post 'update_member_role', to: 'groups#update_member_role'

    resources :invites

    get 'toggleIS', to: 'groups#toggleIS'
    post 'toggleIS', to: 'groups#toggleIS'


    
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

  namespace :api do
    namespace :v1 do
      # api routes
      get '/me' => "credentials#me"
      get '/my_groups' => "credentials#my_groups"
    end
  end
end
