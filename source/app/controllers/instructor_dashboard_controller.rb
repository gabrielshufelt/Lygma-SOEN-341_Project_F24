class InstructorDashboardController < ApplicationController
  before_action :set_instructor, only: %i[index projects teams results settings]
  before_action :authenticate_user!
  before_action :ensure_instructor_role
  before_action :set_selected_course, only: %i[index projects teams results settings]

  def index
    load_instructor_teams
    load_instructor_evaluations
  end

  def projects
    @projects = Project.where(course_id: @selected_course)
  end

  def teams
    load_instructor_teams
    @available_students = User
                          .left_outer_joins(:teams)
                          .where(role: 'student')
                          .group('users.id')
                          .having('COUNT(teams.id) = 0')

    respond_to do |format|
      format.html { render :teams } # Render teams view
      format.json { render json: { teams: @teams, available_students: @available_students } }
    end
  end

  def results
    @results = User
             .joins(evaluations_as_evaluatee: { project: :course })
             .where(evaluations: { project_id: Project.where(course_id: @selected_course.id), status: 'completed' })
             .select(
               'users.id',
               'users.student_id as student_id',
               'users.last_name',
               'users.first_name',
               'AVG(evaluations.cooperation_rating) as cooperation',
               'AVG(evaluations.conceptual_rating) as conceptual_contribution',
               'AVG(evaluations.practical_rating) as practical_contribution',
               'AVG(evaluations.work_ethic_rating) as work_ethic',
               'COUNT(evaluations.id) as num_of_evaluations_received'
             )
             .order('users.last_name ASC, users.first_name ASC')
             .group('users.id', 'users.last_name', 'users.first_name')
             .map do |student|
               {
                id: student.id,
                 student_id: student.student_id,
                 last_name: student.last_name,
                 first_name: student.first_name,
                 cooperation: student.cooperation,
                 conceptual_contribution: student.conceptual_contribution,
                 practical_contribution: student.practical_contribution,
                 work_ethic: student.work_ethic,
                 overall_average: [student.cooperation, student.conceptual_contribution, student.practical_contribution, student.work_ethic].compact.sum / 4,
                 num_of_evaluations_received: student.num_of_evaluations_received
               }
             end
    
    # respond_to do |format|
    #   format.html { render :results } # Render results view
    #   format.json { render json: @results }
    # end
  end

  def detailed_results
    @selected_course = Course.find(params[:course_id]) # Ensure @selected_course is set
    @student = User.find(params[:id])
    @projects = Project.includes(:teams, teams: :students).where(course_id: @selected_course.id)
    @evaluations = Evaluation.includes(:evaluator, :project)
                             .where(evaluatee_id: @student.id, project_id: @projects.pluck(:id), status: 'completed')
  end
   

  def settings
    respond_to do |format|
      format.html { render :settings }
      format.json { render json: { instructor: @instructor, selected_course: @selected_course } }
    end
  end

  def update_settings
    @settings_params = user_params
    result = SettingsUpdateService.update(current_user, @settings_params)
    handle_service_response(result)
  end

  private

  def set_selected_course
    @selected_course = current_user.courses_taught.find_by(id: params[:course_id]) if params[:course_id]

    @selected_course ||= current_user.courses_taught.first

    return if @selected_course

    flash[:alert] = 'No courses available for selection.'
    redirect_to root_path # Or another appropriate path
  end

  def load_instructor_teams
    @teams = Team.where(project_id: Project.where(course_id: @selected_course.id))
  end

  def load_instructor_evaluations
    instructor_projects = Project.where(course_id: @selected_course.id)
    instructor_evaluations = Evaluation.where(project_id: instructor_projects.pluck(:id))

    @completed_evaluations = instructor_evaluations.where(status: 'completed')
    @pending_evaluations = instructor_evaluations.where(status: 'pending')
  end

  def ensure_instructor_role
    return if current_user.instructor?

    flash[:alert] = 'Access denied. Instructors only.'
    redirect_to root_path # Or another appropriate path
  end

  def set_instructor
    @instructor = current_user if current_user.instructor?
  end

  def average_rating(category)
    # Restrict average ratings to the selected course
    @instructor.teams.joins(:project)
               .where(projects: { course_id: @selected_course.id })
               .joins(students: :evaluations_as_evaluatee)
               .average("evaluations.#{category}_rating")
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
      :password
    )
  end
end
