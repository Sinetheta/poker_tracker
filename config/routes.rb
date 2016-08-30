Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }
  root 'games#index'
  get '/archive', to: 'games#archive'
  get '/leaderboard', to: 'games#leaderboard'
  get '/users/:id/history', to: 'users#history'
  resources :games
end
