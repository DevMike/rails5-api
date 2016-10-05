Rails.application.routes.draw do
  apipie
  namespace :api do
    scope :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
          sessions:  'overrides/sessions'
      }
      resources :users, only: [:update, :destroy, :index, :show]
      resources :messages, only: [:index, :create]
      resources :friendships, only: [:index, :create, :destroy]
      resources :posts, only: [:index, :create, :show] do
        resources :comments, only: [:create]
      end
    end
  end
end
