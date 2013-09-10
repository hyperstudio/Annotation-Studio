AnnotationStudio::Application.routes.draw do
  mount RedactorRails::Engine => '/redactor_rails'

  devise_for :users

  resources :documents
  resources :users, only: [:show, :edit]

  authenticated :user do
    root :to => "users#show"
    get 'dashboard', to: 'users#show', as: :dashboard
    get 'annotations', to: 'annotations#index'
    get 'annotations/:id', to: 'annotations#show'
  end

  unauthenticated :user do
    devise_scope :user do 
      get "/" => "devise/sessions#new"
    end
  end

  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config
end
