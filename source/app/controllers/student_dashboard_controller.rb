class StudentDashboardController < ApplicationController
  before_action :set_student

  def index
    @upcoming_evaluations = upcoming_evaluations
    @avg_ratings = avg_ratings
    render json: { upcoming_evaluations: @upcoming_evaluations, avg_ratings: @avg_ratings }
  end

  def teams
    @student_teams = student_teams
    render json: @student_teams
  end

  def evaluations
    @student_evaluations = student_evaluations
    render json: @student_evaluations
  end

  def feedback
    @avg_ratings = avg_ratings
    @received_evaluations = received_evaluations
    render json: { avg_ratings: @avg_ratings, received_evaluations: @received_evaluations }
  end

  private

  def set_student
    @student = current_user if current_user.role == 'student'
  end


  def upcoming_evaluations
    begin
      evaluations = Evaluation.joins(:project).where(evaluator_id: @student.id, status: 'pending')
      evaluations || [] # Return empty array if no evaluations found
    rescue => e
      Rails.logger.error "Error fetching upcoming evaluations: #{e.message}"
      [] # Return an empty array to handle the error
    end
  end
  

  def avg_ratings
    begin
      completed_evaluations = Evaluation.where(evaluatee_id: @student.id, status: 'completed')
      {
        conceptual: completed_evaluations.average(:conceptual_rating) || 0.0,
        cooperation: completed_evaluations.average(:cooperation_rating) || 0.0,
        practical: completed_evaluations.average(:practical_rating) || 0.0,
        work_ethic: completed_evaluations.average(:work_ethic_rating) || 0.0
      }
    rescue => e
      Rails.logger.error "Error calculating average ratings: #{e.message}"
      { conceptual: 0.0, cooperation: 0.0, practical: 0.0, work_ethic: 0.0 } # Default to 0.0 if error occurs
    end
  end


  def student_teams
    begin
      projects = @student.courses.map(&:projects).flatten
      return [] if projects.empty? # Return empty array if no projects are found

      projects.map do |project|
        {
          project_id: project.id,
          student_team: @student.teams.where(project_id: project.id),
          all_teams: project.teams
        }
      end
    rescue => e
      Rails.logger.error "Error fetching student teams: #{e.message}"
      [] # Return an empty array to handle the error
    end
  end

  def student_evaluations
    begin
      projects = @student.courses.map(&:projects).flatten
      return [] if projects.empty? # Return empty array if no projects are found

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
      [] # Return an empty array to handle the error
    end
  end


  def received_evaluations
    begin
      evaluations = Evaluation.where(evaluatee_id: @student.id, status: 'completed')
      evaluations || [] # Return empty array if no evaluations found
    rescue => e
      Rails.logger.error "Error fetching received evaluations: #{e.message}"
      [] # Return an empty array to handle the error
    end
  end  

end
