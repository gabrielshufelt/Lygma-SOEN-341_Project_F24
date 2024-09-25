require 'rails_helper'
require 'faker'

RSpec.describe Project, type: :model do
  let(:team) { Team.create!(name: "Team 1", instructor: instructor) }
  let(:instructor) { User.create!(role: "instructor", first_name: "John", last_name: "Doe", email: "instructor@example.com", password: "password") }

  # Test for presence validation
  it 'is invalid without all necessary fields' do
    project = Project.new
    expect(project).not_to be_valid
    expect(project.errors[:title]).to include("can't be blank")
    expect(project.errors[:due_date]).to include("can't be blank")
    expect(project.errors[:team_id]).to include("can't be blank")
    expect(project.errors[:instructor_id]).to include("can't be blank")
  end
end
