Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }
  root 'games#index'
  get '/archive', to: 'games#archive'
  get '/leaderboard', to: 'games#leaderboard'
  get '/users/:id/history', to: 'users#history', as: 'user_history'
  resources :games
  get '/pizza', to: 'pizza_orders#new'
  post '/pizza', to: 'pizza_orders#create'
  get '/pizza/checkout', to: 'pizza_orders#checkout'
  get '/pizza/checkout_confirm', to: 'pizza_orders#checkout_confirm'
end
