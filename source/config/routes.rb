Rails.application.routes.draw do

  # updated resources here
  resources :teams do
    member do
      post 'add_member'
      delete 'remove_member'
      get 'search_members'
    end
  end


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
  get 'instructor', to: 'instructor_dashboard#index'
  get 'instructor/teams', to: 'instructor_dashboard#teams'
  get 'instructor/results', to: 'instructor_dashboard#results'
  get 'instructor/settings', to: 'instructor_dashboard#settings'
  get 'about', to: 'pages#about'
  get 'contact', to: 'pages#contact'

end
