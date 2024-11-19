Rails.application.routes.draw do
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

  resources :evaluations do
    collection do
      post 'generate_feedback'
    end
  end

  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :instructor_dashboard, only: [:index] do
    collection do
      get 'course/:course_id', to: 'instructor_dashboard#index', as: 'course'
      get 'teams/:course_id', to: 'instructor_dashboard#teams', as: 'teams'
      get 'results/:course_id', to: 'instructor_dashboard#results', as: 'results'
      get 'settings/:course_id', to: 'instructor_dashboard#settings', as: 'settings'
      get 'projects/:course_id', to: 'instructor_dashboard#projects', as: 'projects'
      patch 'settings/:course_id', to: 'instructor_dashboard#update_settings'
    end
  end

  resources :student_dashboard, only: [:index] do
    collection do
      get 'course/:course_id', to: 'student_dashboard#index', as: 'course'
      get 'teams/:course_id', to: 'student_dashboard#teams', as: 'teams'
      get 'evaluations/:course_id', to: 'student_dashboard#evaluations', as: 'evaluations'
      get 'feedback/:course_id', to: 'student_dashboard#feedback', as: 'feedback'
      get 'new_evaluation/:course_id', to: 'student_dashboard#new_evaluation', as: 'new_evaluation'
      patch 'submit_evaluation', to: 'student_dashboard#submit_evaluation'
      get 'project_data', to: 'student_dashboard#project_data', as: 'project_data'
      get 'settings/:course_id', to: 'student_dashboard#settings', as: 'settings'
      patch 'settings/:course_id', to: 'student_dashboard#update_settings'
    end
  end

  resources :course_selection, only: [:index] do
    collection do
      post 'select_course'
      post 'drop_course'
      post 'update_course_selection'
    end
  end

  resources :courses, only: %i[create destroy]
  resources :projects
  resources :evaluations

  get "up" => "rails/health#show", as: :rails_health_check
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
