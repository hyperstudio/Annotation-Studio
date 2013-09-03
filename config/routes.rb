AnnotationStudio::Application.routes.draw do
  devise_for :users

  resources :documents
  resources :users, only: [:show, :edit]

  authenticated :user do
    root :to => "users#show"
    get 'dashboard', to: 'users#show', as: :dashboard
  end

  unauthenticated :user do
    root :to => "users#show"
    devise_scope :user do 
      get "/" => "devise/sessions#new"
    end
  end

  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config
end
