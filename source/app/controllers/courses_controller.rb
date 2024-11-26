class CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_instructor
  before_action :set_course, only: [:destroy]

  def new
    @course = Course.new
  end

  def create
    @course = current_user.courses_taught.build(course_params)
    if @course.save
      redirect_to course_selection_index_path, notice: 'Course was successfully created.'
    else
      redirect_to course_selection_index_path,
                  alert: "Failed to create course: #{@course.errors.full_messages.join(', ')}"
    end
  end

  def destroy
    if @course.destroy
      redirect_to course_selection_index_path, notice: 'Course was successfully deleted.'
    else
      redirect_to course_selection_index_path, alert: 'Failed to delete course.'
    end
  end

  private

  def course_params
    params.require(:course).permit(:code, :title)
  end

  def ensure_instructor
    redirect_to root_path, alert: 'Access denied.' unless current_user.instructor?
  end

  def set_course
    @course = current_user.courses_taught.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to course_selection_index_path, alert: 'Course not found.'
  end
end
