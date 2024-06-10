Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  resources :spottings, only: [:index, :show, :create, :edit, :update, :destroy]
  get "/spottings/success", to: "spottings#success", as: :success_spottings

  resources :rankings, only: [:index]

  get "/search/new", to: "search#new", as: :new_search

  get "/search/results", to: "search#results", as: :results_search

  resources :birds, only: [:show], as: :show_bird

end
