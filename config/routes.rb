Rails.application.routes.draw do
  devise_for :users
  root 'games#index'
  get '/archive', to: 'games#archive'
  resources :games
end
