require 'rails_helper'
require 'faker'

RSpec.describe Evaluation, type: :model do
  let(:student1) do
    User.create!(role: 'student', first_name: 'Jane', last_name: 'Doe', email: 'student@example.com',
                 password: 'password', sex: 'female')
  end
  let(:student2) do
    User.create!(role: 'student', first_name: 'Sebastian', last_name: 'Cruz', email: 'sebastian.cruz@example.com',
                 password: 'password', sex: 'male')
  end
  let(:instructor) do
    User.create!(role: 'instructor', first_name: 'John', last_name: 'Doe', email: 'instructor@example.com',
                 password: 'password', sex: 'male')
  end
  let(:course) { Course.create!(title: 'Example Course', code: 'EX 101', instructor: instructor) }
  let(:project) { Project.create!(title: 'Project 1', due_date: Date.today, course: course) }
  let(:team) { Team.create!(name: 'Team 1', project: project) }

  # Test for presence validation
  it 'is invalid without all necessary fields' do
    evaluation = Evaluation.new
    expect(evaluation).not_to be_valid
    expect(evaluation.errors[:project_id]).to include("can't be blank")
    expect(evaluation.errors[:evaluatee_id]).to include("can't be blank")
    expect(evaluation.errors[:evaluator_id]).to include("can't be blank")
  end

  # Test to ensure evaluations cannot have a completed date in the future
  it 'is invalid if the completed date is in the future' do
    evaluation = Evaluation.new(project_id: project.id, team_id: team.id, evaluator_id: student1.id,
                                evaluatee_id: student2.id, cooperation_rating: 5, conceptual_rating: 5, practical_rating: 5, work_ethic_rating: 5, date_completed: Date.tomorrow)
    evaluation.valid?
    expect(evaluation.errors[:date_completed]).to include('cannot be in the future')
  end

  it 'is invalid if the evaluator is also the evaluatee' do
    evaluation = Evaluation.new(project_id: project.id, team_id: team.id, evaluator_id: student1.id,
                                evaluatee_id: student1.id, cooperation_rating: 5, conceptual_rating: 5, practical_rating: 5, work_ethic_rating: 5, date_completed: Date.tomorrow)
    evaluation.valid?
    expect(evaluation.errors[:evaluator]).to include('cannot be evaluatee')
  end
end
