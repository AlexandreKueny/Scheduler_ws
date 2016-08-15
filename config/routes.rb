Rails.application.routes.draw do
  root to: 'pages#index'

  devise_for :users, :controllers => {:sessions => 'sessions'}

  resources :users do
    resources :collaborators do
      collection do
        get 'remove', to: 'collaborators#remove'
        post 'respond', to: 'collaborators#respond'
      end
    end
    get 'planning', to: 'pages#planning', as: 'planning'
    resources :events
    resources :chat_rooms do
      resources :messages
    end
  end

  get 'users/list', to: 'users#search'

  mount ActionCable.server => '/cable'

end
