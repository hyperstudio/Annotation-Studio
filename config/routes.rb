AnnotationStudio::Application.routes.draw do
  devise_for :users

  resources :documents
  resources :users, only: [:show, :edit]

  authenticated :user do
    root :to => "users#show"
    get 'dashboard', to: 'users#show', as: :dashboard
    get ':username', to: 'users#show', as: :user
    # get ':username/edit', to: 'users#edit', as: :user
  end

  unauthenticated :user do
    devise_scope :user do 
      get "/" => "devise/sessions#new"
    end
  end

  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config
end
