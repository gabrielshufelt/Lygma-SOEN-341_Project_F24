class ApplicationController < ActionController::Base
  before_action :sign_out_on_public_pages
  before_action :set_selected_course

  # Redirect instructors and students to the course selection menu after sign in
  def after_sign_in_path_for(resource)
    course_selection_index_path  
  end

  # Use the same logic for sign up
  def after_sign_up_path_for(resource)
    course_selection_index_path 
  end

  private

  # Force sign-out on certain public pages
  def sign_out_on_public_pages
    public_pages = [about_path, contact_path, home_path]

    if user_signed_in? && public_pages.include?(request.path)
      sign_out(current_user)
      redirect_to root_path, alert: 'You have been signed out.'
    end
  end

  # Ensure @selected_course is set based on session or the first available course
  def set_selected_course
    if current_user
      if current_user.instructor?
        @selected_course = Course.find_by(id: session[:selected_course_id]) || current_user.courses_taught.first
      elsif current_user.student?
        @selected_course = Course.find_by(id: session[:selected_course_id]) || current_user.enrolled_courses.first
      end

      unless @selected_course
        flash[:alert] = "No courses available for selection."
        redirect_to course_selection_index_path and return # Or another appropriate path
      end
    end
  end
end
