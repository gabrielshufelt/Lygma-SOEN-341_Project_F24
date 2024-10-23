Rails.application.routes.draw do
  authenticated :user, ->(u) { u.instructor? } do
    root to: 'instructor_dashboard#index', as: :instructor_root
  end

  authenticated :user, ->(u) { u.student? } do
    root to: 'student_dashboard#index', as: :student_root
  end

  unauthenticated do
    root 'pages#home'
  end

  get 'about', to: 'pages#about'
  get 'contact', to: 'pages#contact'
  get 'home', to: 'pages#home'

  resources :teams do
    member do
      patch 'add_member'
      delete 'remove_member'
      get 'search_members'
    end
  end

  devise_for :users, controllers: { registrations: "users/registrations" }

  resources :instructor_dashboard, only: [:index] do
    collection do
      get 'teams'
      get 'results'
      get 'settings'
    end
  end

  resources :student_dashboard, only: [:index] do
    collection do
      get 'teams'
      get 'evaluations'
      get 'feedback'
      get 'settings'
    end
  end

  # Health check route
  get "up", to: "rails/health#show", as: :rails_health_check
end