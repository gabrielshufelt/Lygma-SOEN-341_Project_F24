class StudentDashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_student_role
  before_action :set_student
  before_action :set_selected_course

  def index
    @upcoming_evaluations = upcoming_evaluations
    @avg_ratings = avg_ratings
    @received_evaluations = received_evaluations

    # New variable to store average ratings by project
    @average_ratings_by_project = calculate_average_ratings_by_project
  end

  def project_data
    project = params[:project] || 'Overall' # Default to 'Overall' if no project is selected

    data = if project == 'Overall'
             # Aggregate average ratings across all projects
             @average_ratings_by_project.values.each_with_object({}) do |ratings, acc|
               ratings.each do |attribute, value|
                 acc[attribute] = (acc[attribute] || 0) + value
               end
             end.transform_values { |sum| (sum / @average_ratings_by_project.size).round(2) }
           else
             # Use the selected project's average ratings
             @average_ratings_by_project[project] || {}
           end

    # Convert data into format for Chartkick and respond as JSON
    render json: data.map { |attribute, avg_rating| [attribute.to_s.humanize, avg_rating] }
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

  def new_evaluation
    @course = Course.find(params[:course_id])
    @projects = @course.projects
    @evaluatees = get_evaluatees_for_new_evaluation
  end

  def submit_evaluation
    @evaluation = Evaluation.find(params[:evaluation][:id])

    if @evaluation.update(evaluation_params)
      flash[:notice] = 'Evaluation submitted successfully.'
      redirect_to evaluations_student_dashboard_index_path(course_id: @evaluation.project.course_id)
    else
      flash[:alert] = 'Failed to submit evaluation. Please try again.'
      redirect_to new_evaluation_student_dashboard_index_path(course_id: @evaluation.project.course_id)
    end
  end

  private

  # Method to calculate average ratings for each project
  def calculate_average_ratings_by_project
    completed_evaluations = Evaluation.joins(:project)
                                      .where(projects: { course_id: @selected_course.id },
                                             evaluatee_id: @student.id,
                                             status: 'completed')
                                      .group_by(&:project)

    completed_evaluations.each_with_object({}) do |(project, evaluations), result|
      result[project.title] = {
        conceptual: evaluations.map(&:conceptual_rating).compact.sum / evaluations.size.to_f,
        cooperation: evaluations.map(&:cooperation_rating).compact.sum / evaluations.size.to_f,
        practical: evaluations.map(&:practical_rating).compact.sum / evaluations.size.to_f,
        work_ethic: evaluations.map(&:work_ethic_rating).compact.sum / evaluations.size.to_f
      }
    end
  end

  def ensure_student_role
    return if current_user.student?

    flash[:alert] = 'Access denied. Students only.'
    redirect_to root_path
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
        completed: Evaluation.where(evaluator_id: @student.id, project_id: project.id,
                                    status: 'completed').map do |eval|
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
            member_name: eval.evaluatee.first_name
          }
        end
      }
    end
  rescue StandardError => e
    Rails.logger.error "Error fetching student evaluations: #{e.message}"
    []
  end

  def received_evaluations
    @progression_data = []

    projects = Project.where(course_id: @selected_course.id).includes(:evaluations)

    evaluations_data = projects.each_with_object({}) do |project, hash|
      individual_ratings = project.evaluations
                                  .where(evaluatee_id: @student.id, status: 'completed')
                                  .order(:date_completed)

      individual_ratings.each do |rating|
        @progression_data << {
          date_completed: rating.date_completed,
          cooperation: rating.cooperation_rating,
          conceptual: rating.conceptual_rating,
          practical: rating.practical_rating,
          work_ethic: rating.work_ethic_rating
        }
      end

      hash[project.id] = {
        project_title: project.title,
        due_date: project.due_date,
        individual_ratings: individual_ratings,
        avg_cooperation: individual_ratings.average(:cooperation_rating)&.round(2),
        avg_conceptual: individual_ratings.average(:conceptual_rating)&.round(2),
        avg_practical: individual_ratings.average(:practical_rating)&.round(2),
        avg_work_ethic: individual_ratings.average(:work_ethic_rating)&.round(2)
      }
    end

    evaluations_data || {}
  end

  def set_selected_course
    @selected_course = Course.find(params[:course_id])
  end

  def get_evaluatees_for_new_evaluation
    projects = Project.where(course_id: @course.id)
    return [] if projects.empty?

    evaluatees = []

    projects.each do |project|
      pending_evaluations = Evaluation.where(evaluator_id: @student.id, project_id: project.id, status: 'pending')

      pending_evaluations.each do |eval|
        evaluatees << {
          id: eval.evaluatee_id,
          name: eval.evaluatee.first_name,
          project_id: project.id,
          project_title: project.title,
          evaluation: eval
        }
      end
    end

    evaluatees.uniq { |e| [e[:id], e[:project_id]] }
  end

  def evaluation_params
    params.require(:evaluation).permit(:id, :cooperation_rating, :conceptual_rating, :practical_rating,
                                       :work_ethic_rating, :comment)
  end
end
