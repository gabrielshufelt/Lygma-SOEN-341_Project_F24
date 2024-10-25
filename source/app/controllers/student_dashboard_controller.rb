class StudentDashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_student_role
  before_action :set_student
  before_action :set_selected_course

  def index
    @upcoming_evaluations = upcoming_evaluations
    @avg_ratings = avg_ratings
    @student_evaluations_progression = received_evaluations
  end

  def teams
    @teams_by_project = teams_by_project
  end

  def evaluations
    @student_evaluations = student_evaluations
  end

  def feedback
    @avg_ratings = avg_ratings
    @received_evaluations = received_evaluations
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

  def upcoming_evaluations
    upcoming_evaluations = Project.where(course_id: @selected_course.id).includes(:evaluations).select do |project|
      project.evaluations.any? { |evaluation| evaluation.status == 'pending' }
    end.map do |project|
      {
        project: project,
        evaluations: project.evaluations.select { |evaluation| evaluation.status == 'pending' }
      }
    end
    upcoming_evaluations.presence || {}
  end

  def avg_ratings
    completed_evaluations = Evaluation.joins(:project)
                                      .where(projects: { course_id: @selected_course.id }, 
                                              evaluatee_id: @student.id, 
                                              status: 'completed')
    return [] if completed_evaluations.empty?

    {
      conceptual: completed_evaluations.average(:conceptual_rating)&.round(2) || 0.0,
      cooperation: completed_evaluations.average(:cooperation_rating)&.round(2) || 0.0,
      practical: completed_evaluations.average(:practical_rating)&.round(2) || 0.0,
      work_ethic: completed_evaluations.average(:work_ethic_rating)&.round(2) || 0.0
    }
  end

  def teams_by_project
    projects = Project.where(course_id: @selected_course.id)
    return [] if projects.empty?

    teams = projects.map do |project|
      student_team = @student.teams.find_by(project_id: project.id)
      {
        project_title: project.title,
        student_team: student_team.present? ? student_team : nil,
        student_team_members: (student_team.members_to_string if student_team.present?),
        all_teams: project.teams
      }
    end
    teams || {}
  end

  def student_evaluations
    projects = Project.where(course_id: @selected_course.id)
    return [] if projects.empty?

    projects.map do |project|
      {
        project_id: project.id,
        project_title: project.title,
        due_date: project.due_date,
        completed: Evaluation.where(evaluator_id: @student.id, project_id: project.id, status: 'completed').map do |eval|
          {
            member_name: eval.evaluatee.first_name,
            cooperation_rating: eval.cooperation_rating,
            conceptual_rating: eval.conceptual_rating,
            practical_rating: eval.practical_rating,
            work_ethic_rating: eval.work_ethic_rating,
            comments: eval.comment,
            date_completed: eval.date_completed
          }
        end,
        pending: Evaluation.where(evaluator_id: @student.id, project_id: project.id, status: 'pending').map do |eval|
          {
            member_name: eval.evaluatee.first_name,
          }
        end
      }
    end
  rescue => e
    Rails.logger.error "Error fetching student evaluations: #{e.message}"
    []
  end

  def received_evaluations
    evaluations = Evaluation.joins(:project)
              .where(evaluatee_id: @student.id, status: 'completed', projects: { course_id: @selected_course.id })
              .where(evaluatee_id: current_user)
              .group('DATE(date_completed)')
              .select('DATE(date_completed) as date_completed,
                      AVG(cooperation_rating) as avg_cooperation,
                      AVG(conceptual_rating) as avg_conceptual,
                      AVG(practical_rating) as avg_practical,
                      AVG(work_ethic_rating) as avg_work_ethic')

    evaluations || []
  end
end
