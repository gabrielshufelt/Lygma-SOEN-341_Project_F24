require 'rails_helper'
require 'faker'

RSpec.describe User, type: :model do
  let(:instructor) { User.create!(role: "instructor", first_name: "John", last_name: "Doe", email: "instructor@example.com", password: "password", sex: "female") }
  let(:student) { User.new(role: "student", first_name: "Jane", last_name: "Doe", email: "student@example.com", password: "password", sex: "male") }

  # Test for presence validation
  it 'is invalid without all necessary fields' do
    user = User.new
    expect(user).not_to be_valid
    expect(user.errors[:first_name]).to include("can't be blank")
    expect(user.errors[:last_name]).to include("can't be blank")
    expect(user.errors[:email]).to include("can't be blank")
    expect(user.errors[:password]).to include("can't be blank")
    expect(user.errors[:role]).to include("can't be blank")
    expect(user.errors[:sex]).to include("can't be blank")
  end

  it 'does not allow an instructor to ratings' do
    instructor.cooperation_rating = 5
    instructor.valid? # Ensure validation is called
    expect(instructor.errors[:base]).to include("Instructors cannot have ratings")
  end

  it 'does not allow more than 6 users to belong to the same team' do
    course = Course.find_or_initialize_by(code: "SOEN 341")
    course.update!(title: "Software Process", instructor_id: instructor.id)

    project = Team.create!(title: "Sprint 1", due_date: Date.tomorrow, course_id: course.id)

    team = Team.create!(name: "Team 1", code: "SOEN 341", project_id: 1)
    
    6.times do
      student = User.create!(role: "student", first_name: "Test", last_name: "User", email: Faker::Internet.email, password: "password", team: team, sex: "other")
      team << student
    end

    new_student = User.new(role: "student", first_name: "Extra", last_name: "User", email: "extra@example.com", password: "password", team: team, sex: "other")
    team.valid?
    expect(team.errors[:team]).to include("cannot have more than 6 students")
  end

  describe "instructor" do
    it "can teach one or many courses" do
      course = Course.find_or_initialize_by(code: "SOEN 341")
      course.update!(title: "Software Process", instructor_id: instructor.id)
      expect(instructor.courses_taught.count).to eq(1)
    end
  end

  describe "student" do
    it "can have many classes" do
      course1 = Course.find_or_initialize_by(code: "SOEN 341")
      course1.update!(title: "Software Process", instructor_id: instructor.id)
      course2 = Course.find_or_initialize_by(code: "ENGR 371")
      course2.update!(title: "Probability and Statistics", instructor_id: instructor.id)
      course3 = Course.find_or_initialize_by(code: "COMP 352")
      course3.update!(title: "Data Structures and Algorithms", instructor_id: instructor.id)
      student.courses << [course1, course2, course3]
      student.save!
      expect(student.courses.count).to eq(3)
    end
  end
end
