require 'rails_helper'
require 'faker'

RSpec.describe Evaluation, type: :model do
  let(:student) { User.create!(role: "student", first_name: "Jane", last_name: "Doe", email: "student@example.com", password: "password", sex: "female") }
  let(:project) { Project.create!(title: "Project 1", due_date: Date.today, team: team, instructor: instructor) }
  let(:team) { Team.create!(name: "Team 1", instructor: instructor, course_name: "SOEN 341") }
  let(:instructor) { User.create!(role: "instructor", first_name: "John", last_name: "Doe", email: "instructor@example.com", password: "password", sex: "male") }

  # Test for presence validation
  it 'is invalid without all necessary fields' do
    evaluation = Evaluation.new
    expect(evaluation).not_to be_valid
    expect(evaluation.errors[:cooperation_rating]).to include("can't be blank")
    expect(evaluation.errors[:conceptual_rating]).to include("can't be blank")
    expect(evaluation.errors[:practical_rating]).to include("can't be blank")
    expect(evaluation.errors[:work_ethic_rating]).to include("can't be blank")
  end

  # Test to ensure evaluations cannot have a completed date in the future
  it 'is invalid if the completed date is in the future' do
    evaluation = Evaluation.new(project: project, student: student, cooperation_rating: 5, conceptual_rating: 5, practical_rating: 5, work_ethic_rating: 5, date_completed: Date.tomorrow)
    evaluation.valid?
    expect(evaluation.errors[:date_completed]).to include("cannot be in the future")
  end
end
