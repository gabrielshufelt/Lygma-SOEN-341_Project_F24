Rails.application.routes.draw do
  resources :teams

  devise_for :users, controllers: { registrations: "users/registrations" }

  resources :instructor_dashboard, only: [:index, :teams, :results] do
    collection do
      get :index
      get :teams
      get :results
    end
  end

  root 'pages#home'

  get "up" => "rails/health#show", as: :rails_health_check
end
