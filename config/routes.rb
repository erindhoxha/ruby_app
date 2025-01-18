Rails.application.routes.draw do
  resources :users
  resources :articles
  root 'pages#home'
  get 'about', to: 'pages#about'
  get 'login', to: 'pages#login'
  get 'signup', to: 'pages#signup'
end
