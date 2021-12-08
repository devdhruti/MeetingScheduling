Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { sessions: 'users/sessions' }
  resources :meetings
  post '/meetings/new', to: 'meetings#create'
  resources :comments
  post '/meetings/:id', to: 'comments#create'
  
  root "homes#index"
end
