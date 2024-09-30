class TeamsController < ApplicationController
  before_action :set_team, only: %i[show edit update destroy add_member remove_member search_members]

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
  end

  # POST /teams or /teams.json
  def create
    @team = Team.new(team_params.merge(instructor_id: current_user.id))

    respond_to do |format|
      if @team.save
        format.html { redirect_to @team, notice: "Team was successfully created." }
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
        format.html { redirect_to @team, notice: "Team was successfully updated." }
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
      format.html { redirect_to teams_path, status: :see_other, notice: "Team was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # POST /teams/:id/add_member
  def add_member
    user = User.find(params[:user_id])
    if user.team_id != @team.id
      user.update!(team_id: @team.id)
      render json: @team.students, status: :ok
    else
      render json: { message: 'User is already a member of this team.' }, status: :unprocessable_entity
    end
  end
  

  # DELETE /teams/:id/remove_member
  def remove_member
    user = User.find(params[:user_id])
    user.update(team_id: nil)
    respond_to do |format|
      format.html { redirect_to edit_team_path(@team), notice: 'Team member was successfully removed.' }
      format.json { render json: @team.students, status: :ok }
    end
  end

  # GET /teams/:id/search_members
  def search_members
    @users = User.where("first_name LIKE ? OR last_name LIKE ?", "%#{params[:query]}%", "%#{params[:query]}%")
                 .where.not(id: @team.students.pluck(:id))
                 .order(:first_name)
    render json: @users
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