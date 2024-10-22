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

  resources :instructor_dashboard, only: [:index] do
    collection do
      get 'course/:course_id', to: 'instructor_dashboard#index', as: 'course'
      get 'teams/:course_id', to: 'instructor_dashboard#teams', as: 'teams'
      get 'results/:course_id', to: 'instructor_dashboard#results', as: 'results'
      get 'settings/:course_id', to: 'instructor_dashboard#settings', as: 'settings'
    end
  end

  resources :student_dashboard, only: [:index] do
    collection do
      get 'course/:course_id', to: 'student_dashboard#index', as: 'course'
      get 'teams/:course_id', to: 'student_dashboard#teams', as: 'teams'
      get 'evaluations/:course_id', to: 'student_dashboard#evaluations', as: 'evaluations'
      get 'feedback/:course_id', to: 'student_dashboard#feedback', as: 'feedback'
    end
  end

  resources :course_selection, only: [:index] do
    collection do
      post :select_course
      post :update_course_selection
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
  # TODO: Remove these routes as they are no longer used
  # get 'instructor', to: 'instructor_dashboard#index'
  # get 'instructor/teams', to: 'instructor_dashboard#teams'
  # get 'instructor/results', to: 'instructor_dashboard#results'
  # get 'instructor/settings', to: 'instructor_dashboard#settings'

end
