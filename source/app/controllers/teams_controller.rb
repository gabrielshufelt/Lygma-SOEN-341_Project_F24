class TeamsController < ApplicationController
  before_action :set_team, only: %i[show edit update destroy add_member remove_member]

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
  end

  # GET /teams/1/edit
  def edit
    @team = Team.find(params[:id])
    @team_members = @team.students
    # refactor to include students with no teams
    @available_students = User.where(role: "student").order(:first_name)
  end

  # POST /teams or /teams.json
  def create
    @team = Team.new

    respond_to do |format|
      if @team.save
        format.html { redirect_to instructor_teams_path, notice: "Team was successfully created." }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1 or /teams/1.json
  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to instructor_teams_path, notice: "Team was successfully updated." }
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
      format.html { redirect_to instructor_teams_path, status: :see_other, notice: "Team was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # PATCH /teams/:id/add_member
  def add_member
    @team = Team.find(params[:id])
    @user = User.find(params[:user_id])
    # refactor to include students with no teas
    @available_students = User.where(role: "student").order(:first_name)
  
    if @team.has_space
      # REFACTOR!!
      # @user.update(team_id: @team.id)
      @team_members = @team.students
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("team-members", partial: "teams/team_members", locals: { team: @team, team_members: @team_members }),
            turbo_stream.replace("available-students", partial: "teams/available_students", locals: { available_students: @available_students })
          ]
        end
        format.html { redirect_to edit_team_path(@team), notice: 'Team member added successfully.' }
        format.json { render json: @team.students, status: :ok }
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: user.errors, status: :unprocessable_entity }
      end
    end
  end
  

  # DELETE /teams/:id/remove_member
  def remove_member
    @team = Team.find(params[:id])
    user = User.find(params[:user_id])
    # Refactor
    # user.update(team_id: nil)
    # @available_students = User.where(role: "student", team_id: nil).order(:first_name)
    @team_members = @team.students

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("team-members", partial: "teams/team_members", locals: { team: @team, team_members: @team_members }),
          turbo_stream.replace("available-students", partial: "teams/available_students", locals: { available_students: @available_students })
        ]
      end
      format.html { redirect_to edit_team_path(@team), notice: 'Team member was successfully removed.' }
      format.json { render json: @team.students, status: :ok }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_team
    @team = Team.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def team_params
    params.require(:team).permit(:name, :course_name)
  end
end