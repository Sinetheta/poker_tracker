Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }
  root 'games#index'
  get '/archive', to: 'games#archive'
  get '/leaderboard', to: 'games#leaderboard'
  resources :games
end
