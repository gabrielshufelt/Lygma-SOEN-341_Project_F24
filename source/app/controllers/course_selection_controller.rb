# app/controllers/course_selection_controller.rb
class CourseSelectionController < ApplicationController
  before_action :authenticate_user!

  def index
    # Fetch courses based on the user's role
    @courses = if current_user.instructor?
                 current_user.courses_taught
               else
                 Course.all
               end
    @student_courses = current_user.enrolled_courses if current_user.student?
  end

  def select_course
    course = Course.find(params[:course_id])
    
    # Store selected course ID in session
    session[:selected_course_id] = course.id

    # Redirect based on role
    if current_user.instructor?
      redirect_to course_instructor_dashboard_index_path(course_id: course.id) # Instructor dashboard
    else
      redirect_to course_student_dashboard_index_path(course_id: course.id) # Student dashboard
    end
  end

  def update_course_selection
    # For students only: handle adding or dropping courses
    return unless current_user.student?

    course = Course.find(params[:course_id])
    action = params[:action_type]  # "add" or "drop"

    if action == "add"
      add_course_for_student(course)
    elsif action == "drop"
      drop_course_for_student(course)
    end

    redirect_to course_selection_index_path
  end

  private

  def add_course_for_student(course)
    if current_user.enrolled_courses.count < 6 && !current_user.enrolled_courses.include?(course)
      current_user.enrolled_courses << course
    else
      flash[:alert] = "You can only enroll in up to 6 courses."
    end
  end

  def drop_course_for_student(course)
    current_user.enrolled_courses.delete(course)
  end
end
