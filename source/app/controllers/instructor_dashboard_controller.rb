class InstructorDashboardController < ApplicationController
  before_action :set_instructor, only: [:index, :teams, :results]  
  before_action :authenticate_user!
  before_action :ensure_instructor_role

  def index
    @num_of_teams = @instructor.teams.count
    @evaluations_completed = evaluations_completed
    @evaluations_pending = evaluations_pending
    @avg_overall_ratings = avg_overall_ratings
    @all_ratings = all_ratings

    respond_to do |format|
      format.html { render :index} # This will render app/views/instructor_dashboard/index.html.erb
      format.json { render json: { num_of_teams: @num_of_teams, evaluations_completed: @evaluations_completed, evaluations_pending: @evaluations_pending, avg_overall_ratings: @avg_overall_ratings, all_ratings: @all_ratings } }
    end
  end

  def teams
    @teams = @instructor.teams
    @available_students = User.where(team: nil, role: "student")
    
    respond_to do |format|
      format.html {render :teams} # Render teams view
      format.json { render json: { teams: @teams, available_students: @available_students } }
    end
  end

  def results
    @results = Evaluation.joins(student: { team: :instructor }).where(status: 'completed')

    respond_to do |format|
      format.html {render :results} # Render results view
      format.json { render json: @results }
    end
  end

  private

  def ensure_instructor_role
    unless current_user.instructor?
      flash[:alert] = "Access denied. Instructors only."
      redirect_to root_path # Or another appropriate path
    end
  end

  def set_instructor
    @instructor = current_user if current_user.instructor?
  end

  def evaluations_completed
    @instructor.teams.joins(students: :evaluations_as_evaluatee).where(evaluations: { status: 'completed' }).count
  end

  def evaluations_pending
    @instructor.teams.joins(students: :evaluations_as_evaluatee).where(evaluations: { status: 'pending' }).count
  end

  def avg_overall_ratings
    ratings_by_category = {
      conceptual_rating: average_rating(:conceptual),
      practical_rating: average_rating(:practical),
      cooperation_rating: average_rating(:cooperation),
      work_ethic_rating: average_rating(:work_ethic)
    }
    ratings_by_category
  end

  def average_rating(category)
    @instructor.teams.joins(students: :evaluations_as_evaluatee).average("evaluations.#{category}_rating")
  end

  def all_ratings
    teams_ratings = {}
    @instructor.teams.each do |team|
      teams_ratings[team.name] = {
        ratings: {
          conceptual_rating: team.evaluations.average(:conceptual_rating),
          practical_rating: team.evaluations.average(:practical_rating),
          cooperation_rating: team.evaluations.average(:cooperation_rating),
          work_ethic_rating: team.evaluations.average(:work_ethic_rating)
        }
      }
    end
    teams_ratings
  end
end
