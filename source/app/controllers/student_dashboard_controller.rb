class StudentDashboardController < ApplicationController
  before_action :set_student

  def index
    @upcoming_evaluations = upcoming_evaluations
    @avg_ratings = avg_ratings
    @student_evaluations_progression = student_evaluations_progression
  end

  def teams
    @student_teams = student_teams
  end

  def evaluations
    @student_evaluations = student_evaluations
  end

  def feedback
    @avg_ratings = avg_ratings
    @received_evaluations = received_evaluations
  end

  private

  def set_student
    @student = current_user if current_user.role == 'student'
  end

  def upcoming_evaluations
    evaluations = Evaluation.joins(:project).where(evaluator_id: @student.id, status: 'pending')
    evaluations || [] # Return empty array if no evaluations found
  end

  def avg_ratings
    completed_evaluations = Evaluation.where(evaluatee_id: @student.id, status: 'completed')
    {
      conceptual: completed_evaluations.average(:conceptual_rating).round(2) || 0.0,
      cooperation: completed_evaluations.average(:cooperation_rating).round(2) || 0.0,
      practical: completed_evaluations.average(:practical_rating).round(2) || 0.0,
      work_ethic: completed_evaluations.average(:work_ethic_rating).round(2) || 0.0
    }
  end

  def student_teams
    projects = @student.courses.map(&:projects).flatten
    return [] if projects.empty? # Return empty array if no projects are found

    projects.map do |project|
      {
        project_id: project.id,
        student_team: @student.teams.where(project_id: project.id),
        all_teams: project.teams
      }
    end
  end

  def student_evaluations
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
  end

  def received_evaluations
    evaluations = Evaluation.where(evaluatee_id: @student.id, status: 'completed')
    evaluations || [] # Return empty array if no evaluations found
  end

  def student_evaluations_progression
    evaluations = Evaluation.where(status: 'completed')
                            .where(evaluatee_id: 2)
                            .group('DATE(date_completed)')
                            .select('DATE(date_completed) as date_completed,
                                    AVG(cooperation_rating) as avg_cooperation,
                                    AVG(conceptual_rating) as avg_conceptual,
                                    AVG(practical_rating) as avg_practical,
                                    AVG(work_ethic_rating) as avg_work_ethic')
    evaluations || []
  end
end
