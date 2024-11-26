# rubocop:disable Metrics/ClassLength
class StudentDashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_student_role
  before_action :set_student
  before_action :set_selected_course

  def index
    @upcoming_evaluations = upcoming_evaluations
    @avg_ratings = avg_ratings
    @received_evaluations = received_evaluations
    @average_ratings_by_project = calculate_average_ratings_by_project
    @project_data = project_data
  end

  def project_data
    project = params[:project] || 'Overall'
    if project == 'Overall'
      @avg_ratings
    else
      @average_ratings_by_project[project] || {}
    end
  end

  def teams
    @teams_by_project = TeamsService.new(@selected_course.id, @student).teams_by_project
  end

  def evaluations
    @student_evaluations = student_evaluations
  end

  def feedback
    @avg_ratings = avg_ratings
    @received_evaluations = received_evaluations
    @learning_insights = fetch_learning_insights
  end

  def new_evaluation
    @course = Course.find(params[:course_id])
    @projects = @course.projects
    @evaluatees = load_evaluatees_for_new_evaluation
  end

  def submit_evaluation
    evaluation = Evaluation.find(params[:evaluation][:id])

    if evaluation.update(evaluation_params)
      handle_successful_evaluation_submission(evaluation)
    else
      handle_failed_evaluation_submission(evaluation)
    end
  end

  def update_settings
    @settings_params = user_params
    result = SettingsUpdateService.update(current_user, @settings_params)
    handle_service_response(result)
  end

  private

  def handle_successful_evaluation_submission(evaluation)
    flash[:notice] = 'Evaluation submitted successfully.'
    redirect_to evaluations_student_dashboard_index_path(course_id: evaluation.project.course_id)
  end

  def handle_failed_evaluation_submission(evaluation)
    flash[:alert] = 'Failed to submit evaluation. Please try again.'
    redirect_to new_evaluation_student_dashboard_index_path(course_id: evaluation.project.course_id)
  end

  def calculate_average_ratings_by_project
    completed_evaluations = fetch_completed_evaluations

    completed_evaluations.each_with_object({}) do |(project, evaluations), result|
      result[project.title] = calculate_project_averages(evaluations)
    end
  end

  def fetch_completed_evaluations
    Evaluation.joins(:project)
              .where(projects: { course_id: @selected_course.id },
                     evaluatee_id: @student.id,
                     status: 'completed')
              .group_by(&:project)
  end

  def calculate_project_averages(evaluations)
    {
      'Cooperation': calculate_average(evaluations.map(&:cooperation_rating).compact).round(2),
      'Conceptual': calculate_average(evaluations.map(&:conceptual_rating).compact).round(2),
      'Practical': calculate_average(evaluations.map(&:practical_rating).compact).round(2),
      'Work Ethic': calculate_average(evaluations.map(&:work_ethic_rating).compact).round(2)
    }
  end

  def calculate_average(ratings)
    return 0.0 if ratings.empty?

    ratings.sum.to_f / ratings.size
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
    projects_with_pending_evaluations = Project.where(course_id: @selected_course.id)
                                               .includes(:evaluations)
                                               .select do |project|
      project.evaluations.any? { |evaluation| evaluation.status == 'pending' }
    end

    upcoming_evaluations = projects_with_pending_evaluations.map do |project|
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

    calculate_project_averages(completed_evaluations)
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
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
            member_name: eval.evaluatee.first_name
          }
        end
      }
    end
  rescue StandardError => e
    Rails.logger.error "Error fetching student evaluations: #{e.message}"
    []
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def received_evaluations
    projects = Project.where(course_id: @selected_course.id).includes(:evaluations)

    evaluations_data = projects.map do |project|
      individual_ratings = project.evaluations
                                  .where(evaluatee_id: @student.id, status: 'completed')
                                  .order(:date_completed)
      {
        project_title: project.title,
        due_date: project.due_date,
        individual_ratings: individual_ratings
      }
    end

    evaluations_data || {}
  end

  def set_selected_course
    @selected_course = Course.find(params[:course_id])
  end

  # rubocop:disable Metrics/AbcSize
  def load_evaluatees_for_new_evaluation
    projects = Project.where(course_id: @course.id)
    return [] if projects.blank?

    evaluatees = projects.flat_map do |project|
      Evaluation.where(evaluator_id: @student.id, project_id: project.id, status: 'pending').map do |eval|
        {
          id: eval.evaluatee_id,
          name: eval.evaluatee.first_name,
          project_id: project.id,
          project_title: project.title,
          evaluation: eval
        }
      end
    end
    # rubocop:enable Metrics/AbcSize

    evaluatees.uniq { |e| [e[:id], e[:project_id]] }
  end

  def evaluation_params
    params.require(:evaluation).permit(:id, :evaluator_id, :evaluatee_id, :project_id, :cooperation_rating,
                                       :conceptual_rating, :practical_rating, :work_ethic_rating, :comment)
  end

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :birth_date,
      :profile_picture,
      :remove_profile_picture,
      :current_password,
      :password,
      :student_id
    )
  end
  
  def collected_evaluations
    @evaluations = Evaluation.where(evaluatee_id: @student.id, status: 'completed').order(:date_completed)
  end

  def aggregate_evaluation_data
    @evaluation_data = @evaluations.group_by(&:project_id).map do |project_id, evaluations|
      project = Project.find(project_id)
      
      # Extract ratings and remove nil values
      cooperation_ratings = evaluations.map(&:cooperation_rating).compact
      conceptual_ratings = evaluations.map(&:conceptual_rating).compact
      practical_ratings = evaluations.map(&:practical_rating).compact
      work_ethic_ratings = evaluations.map(&:work_ethic_rating).compact
  
      # Calculate averages
      avg_cooperation = calculate_average(cooperation_ratings).round(2)
      avg_conceptual = calculate_average(conceptual_ratings).round(2)
      avg_practical = calculate_average(practical_ratings).round(2)
      avg_work_ethic = calculate_average(work_ethic_ratings).round(2)
  
      {
        project_title: project.title,
        date_completed: evaluations.map(&:date_completed).compact.max,
        avg_cooperation: avg_cooperation,
        avg_conceptual: avg_conceptual,
        avg_practical: avg_practical,
        avg_work_ethic: avg_work_ethic,
        comments: evaluations.map(&:comment).compact
      }
    end
  end

  def fetch_learning_insights
    # Check if insights exist and are up-to-date
    if @student.learning_insights.present? && insights_up_to_date?
      return @student.learning_insights
    else
      
      collected_evaluations  # Ensure @evaluations is set
      aggregate_evaluation_data

      if @evaluation_data.present?
        insights_service = LearningInsightsService.new(@evaluation_data)
        insights = insights_service.generate_insights

        # Save insights to student's record
        @student.update(
          learning_insights: insights,
          insights_updated_at: Time.current
        )
  
        return insights
      else
        return nil
      end
    end
  end

  def insights_up_to_date?
    latest_evaluation_date = Evaluation.where(evaluatee_id: @student.id, status: 'completed').maximum(:updated_at)
    return false if latest_evaluation_date.nil? || @student.insights_updated_at.nil?
  
    @student.insights_updated_at >= latest_evaluation_date
  end
end
# rubocop:enable Metrics/ClassLength