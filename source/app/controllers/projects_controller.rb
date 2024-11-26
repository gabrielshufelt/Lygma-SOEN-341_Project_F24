class ProjectsController < ApplicationController
  before_action :authorize_instructor!, except: %i[index show]
  before_action :set_project, only: %i[show edit update destroy]

  # GET /projects or /projects.json
  def index
    @projects = Project.all
  end

  # GET /projects/1 or /projects/1.json
  def show; end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit; end

  # POST /projects or /projects.json
  def create
    @project = Project.new(project_params)
    @project.course_id = @selected_course.id if @selected_course

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    @project.destroy!

    respond_to do |format|
      format.html do
        redirect_to projects_instructor_dashboard_index_path(course_id: @selected_course.id), status: :see_other,
                                                                                              notice: 'Project was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  def authorize_instructor!
    redirect_to projects_path, alert: 'You are not authorized to perform this action.' unless current_user&.instructor?
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def project_params
    params.require(:project).permit(:title, :description, :due_date, :maximum_team_size, :course_id)
  end
end
