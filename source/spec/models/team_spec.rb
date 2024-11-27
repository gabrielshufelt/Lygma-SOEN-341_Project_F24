require 'rails_helper'
require 'faker'

RSpec.describe Team, type: :model do
  let(:instructor) do
    User.find_or_create_by(email: 'instructor@example.com') do |user|
      user.first_name = 'John'
      user.last_name = 'Doe'
      user.role = 'instructor'
      user.password = 'password'
      user.sex = 'male'
    end
  end

  let(:course) do
    Course.find_or_create_by(code: 'EX 202') do |course|
      course.title = 'Example Course 2'
      course.instructor = instructor
    end
  end

  let(:project) do
    Project.find_or_create_by(title: 'Sprint 1') do |project|
      project.course = course
      project.due_date = Date.tomorrow
      project.maximum_team_size = 6
    end
  end

  it 'is invalid without all necessary fields' do
    team = Team.new
    expect(team).not_to be_valid
    expect(team.errors[:name]).to include("can't be blank")
    expect(team.errors[:project_id]).to include("can't be blank")
  end

  it 'does not allow more than 6 users to belong to the same team' do
    team = Team.find_or_create_by(name: 'Team 1', project: project)

    # Add 6 students with unique and valid student_ids
    6.times do |i|
      student = User.find_or_create_by(email: Faker::Internet.email) do |user|
        user.role = 'student'
        user.first_name = 'Test'
        user.last_name = 'User'
        user.password = 'password'
        user.sex = 'other'
        user.student_id = "4000000#{i}"
      end
      team.add_student(student)
    end

    expect(team.students.count).to eq(6)

    # Try to add a 7th student with a unique and valid student_id
    extra_student = User.find_or_create_by(email: Faker::Internet.email) do |user|
      user.role = 'student'
      user.first_name = 'Extra'
      user.last_name = 'User'
      user.password = 'password'
      user.sex = 'other'
      user.student_id = '40000007'
    end
    result = team.add_student(extra_student)

    expect(result).to be_falsey
    expect(team.errors[:team]).to include("cannot have more than #{project.maximum_team_size} students")
    expect(team.students.count).to eq(6)
  end
end
