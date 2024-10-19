Rails.application.routes.draw do
  authenticated :user, ->(u) { u.instructor? } do
    root to: 'instructor_dashboard#index', as: :instructor_root
  end

  authenticated :user, ->(u) { u.student? } do
    # this will change to student_dashboard#index
    root to: 'pages#home', as: :student_root
  end

  unauthenticated do
    root 'pages#home'
  end

  resources :pages, only: [:about, :contact, :home] do
    collection do
      get :about
      get :contact
      get :home
    end
  end

  # updated resources here
  resources :teams do
    member do
      patch 'add_member'
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

  resources :student_dashboard, only: [:index] do
    collection do
      get 'teams'
      get 'evaluations'
      get 'feedback'
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
  get 'instructor', to: 'instructor_dashboard#index'
  get 'instructor/teams', to: 'instructor_dashboard#teams'
  get 'instructor/results', to: 'instructor_dashboard#results'
  get 'instructor/settings', to: 'instructor_dashboard#settings'

end
