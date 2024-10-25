class StudentDashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_student_role
  before_action :set_student
  before_action :set_selected_course

  def index
    @upcoming_evaluations = upcoming_evaluations
    @avg_ratings = avg_ratings
    
    respond_to do |format|
      format.html
      format.json { render json: { upcoming_evaluations: @upcoming_evaluations, avg_ratings: @avg_ratings } }
    end
  end

  def teams
    @student_teams = student_teams
    
    respond_to do |format|
      format.html
      format.json { render json: @student_teams }
    end
  end

  def evaluations
    @student_evaluations = student_evaluations
    
    respond_to do |format|
      format.html
      format.json { render json: @student_evaluations }
    end
  end

  def feedback
    @avg_ratings = avg_ratings
    @received_evaluations = received_evaluations
    
    respond_to do |format|
      format.html
      format.json { render json: { avg_ratings: @avg_ratings, received_evaluations: @received_evaluations } }
    end
  end

  private

  def ensure_student_role
    unless current_user.student?
      flash[:alert] = "Access denied. Students only."
      redirect_to root_path
    end
  end

  def set_student
    @student = current_user if current_user.role == 'student'
  end

  def set_selected_course
    if params[:course_id]
      @selected_course = @student.courses.find_by(id: params[:course_id])
    end
  
    @selected_course ||= @student.courses.first
  
    unless @selected_course
      flash[:alert] = "No courses available for selection."
      redirect_to root_path # Or another appropriate path
    end
  end

  def upcoming_evaluations
    Evaluation.joins(:project)
              .where(evaluator_id: @student.id, status: 'pending', projects: { course_id: @selected_course.id })
  rescue => e
    Rails.logger.error "Error fetching upcoming evaluations: #{e.message}"
    []
  end

  def avg_ratings
    completed_evaluations = Evaluation.joins(:project)
                                      .where(evaluatee_id: @student.id, status: 'completed', projects: { course_id: @selected_course.id })
    {
      conceptual: completed_evaluations.average(:conceptual_rating) || 0.0,
      cooperation: completed_evaluations.average(:cooperation_rating) || 0.0,
      practical: completed_evaluations.average(:practical_rating) || 0.0,
      work_ethic: completed_evaluations.average(:work_ethic_rating) || 0.0
    }
  rescue => e
    Rails.logger.error "Error calculating average ratings: #{e.message}"
    { conceptual: 0.0, cooperation: 0.0, practical: 0.0, work_ethic: 0.0 }
  end

  def student_teams
    projects = @selected_course.projects
    projects.map do |project|
      {
        project_id: project.id,
        student_team: @student.teams.where(project_id: project.id),
        all_teams: project.teams
      }
    end
  rescue => e
    Rails.logger.error "Error fetching student teams: #{e.message}"
    []
  end

  def student_evaluations
    projects = @selected_course.projects
    projects.map do |project|
      {
        project_id: project.id,
        due_date: project.due_date,
        completed: Evaluation.where(evaluator_id: @student.id, project_id: project.id, status: 'completed'),
        pending: Evaluation.where(evaluator_id: @student.id, project_id: project.id, status: 'pending')
      }
    end
  rescue => e
    Rails.logger.error "Error fetching student evaluations: #{e.message}"
    []
  end

  def received_evaluations
    Evaluation.joins(:project)
              .where(evaluatee_id: @student.id, status: 'completed', projects: { course_id: @selected_course.id })
  rescue => e
    Rails.logger.error "Error fetching received evaluations: #{e.message}"
    []
  end
end
