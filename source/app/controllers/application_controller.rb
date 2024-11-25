class ApplicationController < ActionController::Base
  before_action :sign_out_on_public_pages
  before_action :set_selected_course, unless: :skip_set_selected_course?
  before_action :check_student_id, if: :user_signed_in? # added this (ahmad)

  # Redirect instructors and students to the course selection menu after sign in
  def after_sign_in_path_for(_resource)
    course_selection_index_path
  end

  # Use the same logic for sign up
  def after_sign_up_path_for(_resource)
    course_selection_index_path
  end

  def after_sign_out_path_for(_resource_or_scope)
    root_path # or any other path you want to redirect to after logout
  end

  private

  # Force sign-out on certain public pages
  def sign_out_on_public_pages
    public_pages = [about_path, contact_path, home_path]

    return unless user_signed_in? && public_pages.include?(request.path)

    sign_out(current_user)
    redirect_to root_path, alert: 'You have been signed out.'
  end

  # Ensure @selected_course is set based on session or the first available course
  def set_selected_course
    return unless current_user

    @selected_course = find_selected_course
    handle_no_course_available if @selected_course.nil? && !current_page?(course_selection_index_path)
  end

  def find_selected_course
    course_id = session[:selected_course_id]
    return Course.find_by(id: course_id) || current_user.courses_taught.first if current_user.instructor?

    Course.find_by(id: course_id) || current_user.enrolled_courses.first if current_user.student?
  end

  def handle_no_course_available
    flash[:alert] = 'No courses available for selection.'
    redirect_to course_selection_index_path
  end

  def skip_set_selected_course?
    devise_controller? ||
      (controller_name == 'course_selection' && action_name == 'index') ||
      creating_or_adding_course?
  end

  def creating_or_adding_course?
    (controller_name == 'courses' && action_name == 'create') ||
      (controller_name == 'course_selection' && %w[update_course_selection create].include?(action_name))
  end

  def handle_service_response(result)
    if result[:redirect] == :logout
      handle_logout(result[:notice])
    else
      handle_flash_messages(result)
      redirect_to settings_redirect_path(params[:course_id])
    end
  end

  # Redirect path based on user role
  def settings_redirect_path(course_id)
    if current_user.instructor?
      settings_instructor_dashboard_index_path(course_id: course_id)
    else
      settings_student_dashboard_index_path(course_id: course_id)
    end
  end

  # Redirect students without a student_id to their settings page
  def check_student_id
    return unless current_user.student? && current_user.student_id.blank?

    redirect_to edit_user_registration_path, alert: 'Please enter your student ID.'
  end

  def handle_logout(notice)
    sign_out current_user
    redirect_to new_user_session_path, notice: notice
  end

  def handle_flash_messages(result)
    flash[:notice] = result[:notice] if result[:notice]
    flash[:alert] = result[:alert] if result[:alert]
  end
end
