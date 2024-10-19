require 'rails_helper'
require 'faker'

RSpec.describe Team, type: :model do
  let(:instructor) { User.create!(role: "instructor", first_name: "John", last_name: "Doe", email: "instructor@example.com", password: "password", sex: "male") }
  let(:course) { Course.create!(title: "Example Course 2", code: "EX 202", instructor: instructor)}
  let(:project) { Project.create!(title: "Sprint 1", due_date: Date.tomorrow, course_id: course.id) }

  it 'is invalid without all necessary fields' do
    team = Team.new
    expect(team).not_to be_valid
    expect(team.errors[:name]).to include("can't be blank")
    expect(team.errors[:project_id]).to include("can't be blank")
  end

  it 'does not allow more than 6 users to belong to the same team' do
    team = Team.create!(name: "Team 1", project_id: 1)

    # Add 6 students
    6.times do
      team.add_student(User.create!(role: "student", first_name: "Test", last_name: "User", email: Faker::Internet.email, password: "password", sex: "other"))
    end

    expect(team.students.count).to eq(6)

    # Try to add a 7th student
    result = team.add_student(User.create!(role: "student", first_name: "Extra", last_name: "User", email: Faker::Internet.email, password: "password", sex: "other"))

    expect(result).to be_falsey
    expect(team.errors[:team]).to include("cannot have more than 6 students")
    expect(team.students.count).to eq(6)
  end
end
