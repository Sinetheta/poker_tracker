Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }
  root 'games#index'
  get '/archive', to: 'games#archive'
  get '/leaderboard', to: 'games#leaderboard'
  get '/users/:id/history', to: 'users#history', as: 'user_history'
  resources :games
  resources :pizza_configs
  resources :saved_orders
  resources :product, only: :show
  post '/product(/:id)', to: 'product#add_to_saved_order'
  get '/pizza', to: 'pizza_orders#new'
  post '/pizza', to: 'pizza_orders#create'
  get '/pizza/random', to: 'pizza_orders#random_order'
  get '/pizza/create', to: 'pizza_orders#create_pizza'
  get '/pizza/checkout', to: 'pizza_orders#checkout'
  get '/pizza/checkout_confirm', to: 'pizza_orders#checkout_confirm'
end
