class TeamsController < ApplicationController
  before_action :set_team, only: %i[show edit update destroy add_member remove_member]
  before_action :authenticate_user!

  # GET /teams or /teams.json
  def index
    @teams = Team.all
  end

  # GET /teams/1 or /teams/1.json
  def show
  end

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
        format.html { redirect_to teams_instructor_dashboard_index_path(course_id: @selected_course.id), notice: "Team was successfully created." }
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
        format.html { redirect_to teams_instructor_dashboard_index_path(course_id: @selected_course.id), notice: "Team was successfully updated." }
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
      format.html { redirect_to teams_instructor_dashboard_index_path(course_id: @selected_course.id), status: :see_other, notice: "Team was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def load_projects_for_instructors
    if current_user.role == 'instructor'
      @projects = Project.where(course_id: current_user.courses_taught.pluck(:id))
    else
      @projects = []
    end
  end

  def available_students
    @available_students = User
      .left_outer_joins(:teams)
      .where(role: "student")
      .group('users.id')
      .having('COUNT(teams.id) = 0')
  end

  # PATCH /teams/:id/add_member
  def add_member
    @team = Team.find(params[:id])
    @user = User.find(params[:user_id])
    available_students

    # Check if the user is already part of another team for the same project
    current_team = @user.teams.find_by(project_id: @team.project_id)
    if current_team && current_team != @team
      current_team.remove_student(@user)
    end

    if @team.add_student(@user)
      @team_members = @team.students
      @teams_by_project = TeamsService.new(@selected_course.id, @user).teams_by_project

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("team-members", partial: "teams/team_members", locals: { team: @team, team_members: @team_members }),
            turbo_stream.replace("available-students", partial: "teams/available_students", locals: { available_students: @available_students }),
            turbo_stream.replace("student-teams", template: "student_dashboard/teams", locals: {teams_by_project: @teams_by_project}),
            turbo_stream.append("student-teams", "<script>initializeCollapsible();</script>") # re-trigger collapsible box initialization
          ]
        end
        format.html { redirect_to edit_team_path(@team), notice: 'Team member added successfully.' }
        format.json { render json: @team.students, status: :ok }
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end
  

  # DELETE /teams/:id/remove_member
  def remove_member
    @team = Team.find(params[:id])
    @user = User.find(params[:user_id])
  
    if @team.remove_student(@user)
      @team_members = @team.students
      @teams_by_project = TeamsService.new(@selected_course.id, @user).teams_by_project
      available_students
  
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("team-members", partial: "teams/team_members", locals: { team: @team, team_members: @team_members }),
            turbo_stream.replace("available-students", partial: "teams/available_students", locals: { available_students: @available_students }),
            turbo_stream.replace("student-teams", template: "student_dashboard/teams", locals: {teams_by_project: @teams_by_project}),
            turbo_stream.append("student-teams", "<script>initializeCollapsible();</script>") # re-trigger collapsible box initialization
          ]
        end
        format.html { redirect_to edit_team_path(@team), notice: 'Team member was successfully removed.' }
        format.json { render json: @team.students, status: :ok }
      end
    else
      respond_to do |format|
        format.html { redirect_to edit_team_path(@team), alert: 'Failed to remove team member.' }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end
  

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_team
    @team = Team.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def team_params
    params.require(:team).permit(:name, :description, :project_id)
  end
end