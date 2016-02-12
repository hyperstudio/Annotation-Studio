AnnotationStudio::Application.routes.draw do

  get 'public/:id' => 'public_documents#show'

  devise_for :users, controllers: {registrations: 'registrations'}

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # catalog routes
  get 'documents/catalog', to: 'catalog#index'
  get 'documents/catalog/image/:eid', to: 'catalog#image'
  get 'documents/catalog/reference/:eid', to: 'catalog#reference'

  resources :documents do
    resources :annotations
    post :set_default_state
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

	get 'exception_test' => "annotations#exception_test"
  # root :to => "devise/sessions#new"
end
