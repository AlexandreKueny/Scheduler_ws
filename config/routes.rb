Rails.application.routes.draw do
  root to: 'pages#index'

  devise_for :users

  resources :users do
    resources :chat_rooms do
      resources :messages
    end
  end

  get '/planning', to: 'pages#planning', as: :planning
  get '/collaborators', to: 'pages#collaborators', as: :collaborators
  get '/users/list', to: 'users#search'
  get '/set_unread', to: 'chat_rooms_users#set_unread'

  mount ActionCable.server => '/cable'

end
