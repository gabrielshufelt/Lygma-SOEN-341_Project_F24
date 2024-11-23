require 'pexels'

PexelsClient = Pexels::Client.new(ENV['PEXELS_API_KEY'])

class CourseSelectionController < ApplicationController
  before_action :authenticate_user!

  def index
    load_courses
    assign_image_urls
    handle_no_courses_flash
  end

  def select_course
    course = Course.find(params[:course_id])
    session[:selected_course_id] = course.id
    redirect_to_dashboard(course)
  end

  def update_course_selection
    course = Course.find(params[:course_id])
    if can_enroll_in_course?(course)
      current_user.enrolled_courses << course
      flash[:notice] = "You have successfully enrolled in #{course.code}."
    else
      flash[:alert] = "You can only enroll in up to 6 courses or you're already enrolled in this course."
    end
    redirect_to course_selection_index_path
  end

  def drop_course
    course = Course.find(params[:course_id])
    if current_user.enrolled_courses.include?(course)
      current_user.enrolled_courses.delete(course)
      flash[:notice] = "You have successfully dropped #{course.code}."
    else
      flash[:alert] = 'You are not enrolled in this course.'
    end
    redirect_to course_selection_index_path
  end

  def create
    @course = current_user.courses_taught.build(course_params)
    if @course.save
      flash[:notice] = 'Course successfully created.'
    else
      flash[:alert] = "Failed to create course: #{@course.errors.full_messages.join(', ')}"
    end
    redirect_to course_selection_index_path
  end

  private

  # Load courses for the user based on their role
  def load_courses
    if current_user.instructor?
      @courses = current_user.courses_taught
    else
      load_student_courses
    end
  end

  def load_student_courses
    @student_courses = current_user.enrolled_courses
    @available_courses = Course.where.not(id: @student_courses.pluck(:id))
  end

  # Assign image URLs for courses if they don't already exist
  def assign_image_urls
    (@courses || @student_courses || []).each do |course|
      course.image_url ||= fetch_image_url(course.title)
    end
  end

  # Display a flash message if no courses are available
  def handle_no_courses_flash
    return unless no_courses_available?

    flash.now[:alert] =
      "No courses available. #{if current_user.instructor?
                                 'Create a new course to get started.'
                               else
                                 'Please contact your instructor.'
                               end}"
  end

  def no_courses_available?
    (@courses.blank? && current_user.instructor?) ||
      (@student_courses.blank? && @available_courses.blank? && current_user.student?)
  end

  # Redirect to the appropriate dashboard
  def redirect_to_dashboard(course)
    path = if current_user.instructor?
             course_instructor_dashboard_index_path(course_id: course.id)
           else
             course_student_dashboard_index_path(course_id: course.id)
           end
    redirect_to path
  end

  # Check if the user can enroll in a course
  def can_enroll_in_course?(course)
    current_user.enrolled_courses.count < 6 && !current_user.enrolled_courses.include?(course)
  end

  # Fetch the image URL for a course
  def fetch_image_url(course_title)
    search_results = PexelsClient.photos.search(course_title, per_page: 1)
    if search_results&.photos&.any?
      search_results.photos.first.src['medium']
    else
      default_image_url
    end
  rescue StandardError => e
    Rails.logger.error "Error fetching image for #{course_title}: #{e.message}"
    default_image_url
  end

  # Default placeholder image URL
  def default_image_url
    'https://via.placeholder.com/250x120?text=No+Image+Available'
  end

  # Whitelist course parameters
  def course_params
    params.require(:course).permit(:code, :title)
  end
end
