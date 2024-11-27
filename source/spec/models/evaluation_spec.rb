require 'rails_helper'
require 'faker'

RSpec.describe Evaluation, type: :model do
  let(:student1) do
    User.find_or_initialize_by(email: 'student@example.com')
  end
  let(:student2) do
    User.find_or_initialize_by(email: 'sebastian.cruz@example.com')
  end
  let(:instructor) do
    User.find_or_initialize_by(email: 'instructor@example.com')
  end
  let(:course) { Course.find_or_initialize_by(code: 'EX 101') }
  let(:project) { Project.find_or_initialize_by(title: 'Project 1') }
  let(:team) { Team.find_or_initialize_by(name: 'Team 1') }

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
                                evaluatee_id: student2.id, cooperation_rating: 5, conceptual_rating: 5,
                                practical_rating: 5, work_ethic_rating: 5, date_completed: Date.tomorrow)
    evaluation.valid?
    expect(evaluation.errors[:date_completed]).to include('cannot be in the future')
  end

  it 'is invalid if the evaluator is also the evaluatee' do
    evaluation = Evaluation.new(project_id: project.id, team_id: team.id, evaluator_id: student1.id,
                                evaluatee_id: student1.id, cooperation_rating: 5, conceptual_rating: 5,
                                practical_rating: 5, work_ethic_rating: 5, date_completed: Date.tomorrow)
    evaluation.valid?
    expect(evaluation.errors[:evaluator]).to include('cannot be evaluatee')
  end
end
