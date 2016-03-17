Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'tournaments#index'

  resources :tournaments, only: :show, id: Tournament::SLUG_PATTERN do
    member do
      get 'challenge'
      get 'leaderboard'
    end
  end
  resources :tournaments, only: :none do
    resources :brackets, path: 'brackets',
        tournament_id: Tournament::SLUG_PATTERN
  end

  namespace :admin do
    root to: 'tournaments#index'

    resources :tournaments, id: Tournament::SLUG_PATTERN
    resources :tournaments, only: :none do
      resources :teams, only: [:new, :create, :edit, :update],
        tournament_id: Tournament::SLUG_PATTERN
      resources :games, only: [:edit, :update],
        tournament_id: Tournament::SLUG_PATTERN
    end
  end

  match "/404" => "errors#404", via: [ :get, :post, :patch, :delete ]

end
