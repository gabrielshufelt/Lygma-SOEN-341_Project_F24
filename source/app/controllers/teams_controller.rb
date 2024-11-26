# rubocop:disable Metrics/ClassLength
class TeamsController < ApplicationController
  before_action :set_team, only: %i[show edit update destroy manage_member]
  before_action :authenticate_user!

  # GET /teams or /teams.json
  def index
    @teams = Team.all
  end

  # GET /teams/1 or /teams/1.json
  def show; end

  # GET /teams/new
  def new
    @team = Team.new
    load_projects_for_instructors
  end

  # GET /teams/1/edit
  def edit
    @team = Team.find(params[:id])
    @team_members = @team.students
    available_students
    load_projects_for_instructors
  end

  # POST /teams or /teams.json
  def create
    @team = Team.new(team_params)
    load_projects_for_instructors

    respond_to do |format|
      if @team.save
        format.html do
          redirect_to teams_instructor_dashboard_index_path(course_id: @selected_course.id),
                      notice: 'Team was successfully created.'
        end
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1 or /teams/1.json
  def update
    available_students
    load_projects_for_instructors

    respond_to do |format|
      if @team.update(team_params)
        format.html do
          redirect_to teams_instructor_dashboard_index_path(course_id: @selected_course.id),
                      notice: 'Team was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1 or /teams/1.json
  def destroy
    @team.destroy!

    respond_to do |format|
      format.html do
        redirect_to teams_instructor_dashboard_index_path(course_id: @selected_course.id), status: :see_other,
                                                                                           notice: 'Team was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  def load_projects_for_instructors
    @projects = if current_user.role == 'instructor'
                  Project.where(course_id: current_user.courses_taught.pluck(:id))
                else
                  []
                end
  end

  def available_students
    @available_students = User.left_outer_joins(:teams).where(role: 'student').group('users.id').having('COUNT(teams.id) = 0')
  end

  # PATCH/DELETE /teams/:id/manage_member
  def manage_member
    @team = Team.find(params[:id])
    @user = User.find(params[:user_id])

    # Check if the user is already part of another team for the same project
    current_team = @user.teams.find_by(project_id: @team.project_id)
    if current_team && current_team != @team
      current_team.remove_student(@user)
    end

    if perform_member_operation(params[:operation])
      load_team_data
      respond_success(params[:operation])
    else
      respond_failure(params[:operation])
    end
  end

  private

  def perform_member_operation(operation)
    operation == 'add' ? @team.add_student(@user) : @team.remove_student(@user)
  end

  def load_team_data
    @team_members = @team.students
    @teams_by_project = TeamsService.new(@selected_course.id, @user).teams_by_project
    available_students
  end

  def respond_success(operation)
    respond_to do |format|
      format.turbo_stream { render_turbo_streams }
      format.html { redirect_to role_based_dashboard_path, notice: member_success_message(operation) }
      format.json { render json: @team.students, status: :ok }
    end
  end

  def respond_failure(operation)
    respond_to do |format|
      format.html { redirect_to role_based_dashboard_path, alert: member_failure_message(operation) }
      format.json { render json: @team.errors, status: :unprocessable_entity }
    end
  end

  def render_turbo_streams
    render turbo_stream: [
      turbo_stream.replace('team-members', partial: 'teams/team_members',
                                           locals: { team: @team, team_members: @team_members }),
      turbo_stream.replace('available-students', partial: 'teams/available_students',
                                                 locals: { available_students: @available_students }),
      turbo_stream.replace('student-teams', template: 'student_dashboard/teams',
                                            locals: { teams_by_project: @teams_by_project }),
      turbo_stream.append('student-teams', '<script>initializeCollapsible();</script>')
    ]
  end

  def member_success_message(operation)
    operation == 'add' ? 'Team member added successfully.' : 'Team member was successfully removed.'
  end

  def member_failure_message(operation)
    operation == 'add' ? 'Failed to add team member.' : 'Failed to remove team member.'
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_team
    @team = Team.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def team_params
    params.require(:team).permit(:name, :description, :project_id)
  end

  def role_based_dashboard_path
    path send("teams_#{current_user.role}_dashboard_index_path", course_id: @selected_course.id)
  end

end
# rubocop:enable Metrics/ClassLength
