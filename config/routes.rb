AnnotationStudio::Application.routes.draw do
  root :to => 'documents#index'

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  devise_for :users

  # Allow annotators to view their work
  match 'users/:id' => 'users#show'

  resources :documents
end
