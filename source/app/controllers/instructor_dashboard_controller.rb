class InstructorDashboardController < ApplicationController
  before_action :set_instructor, only: [:index, :teams, :results]

  def index
    render json: {
      num_of_teams: @instructor.teams.count,
      evaluations_completed: evaluations_completed,
      evaluations_pending: evaluations_pending,
      avg_overall_ratings: avg_overall_ratings,
      all_ratings: all_ratings
    }
  end

  def teams
    @teams = @instructor.teams
    @available_students = Student.where(team: nil)
    render json: { teams: @teams, available_students: @available_students }
  end

  def results
    @results = @instructor.evaluations.completed
    render json: @results
  end

  private

  def set_instructor
    @instructor = current_user if current_user.is_instructor?
  end

  def evaluations_completed
    @instructor.evaluations.completed.count
  end

  def evaluations_pending
    @instructor.evaluations.pending.count
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
    @instructor.teams.joins(:evaluations).average("evaluations.#{category}_rating")
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
