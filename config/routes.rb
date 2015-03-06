AnnotationStudio::Application.routes.draw do

  get 'public/:id' => 'public_documents#show'

  devise_for :users

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :documents do
    resources :annotations
  end
  resources :users, only: [:show, :edit]


  authenticated :user do
    root :to => "users#show"
    get 'dashboard', to: 'users#show', as: :dashboard
    get 'annotations', to: 'annotations#index'
    get 'annotations/:id', to: 'annotations#show'
    get 'groups', to: 'groups#index'
    get 'groups/:id', to: 'groups#show'
  end

  unauthenticated :user do
    devise_scope :user do
      get "/" => "devise/sessions#new"
    end
  end

  # root :to => "devise/sessions#new"
end
