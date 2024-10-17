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

p
  it 'does not allow an instructor to have a team or ratings' do
    instructor.team_id = 1
    instructor.cooperation_rating = 5
    instructor.valid? # Ensure validation is called
    expect(instructor.errors[:team_id]).to include("Must be nil for instructors")
    expect(instructor.errors[:base]).to include("Instructors cannot have ratings")
  end



  it 'does not allow more than 6 users to belong to the same team' do
    team = Team.create!(name: "Team 1", instructor: instructor, course_name: "SOEN 341")  # Ensure the instructor is assigned properly
    7.times {User.create!(role: "student", first_name: "Test", last_name: "User", email: Faker::Internet.email, password: "password", team: team, sex: "other") }

    new_student = User.new(role: "student", first_name: "Extra", last_name: "User", email: "extra@example.com", password: "password", team: team, sex: "other")
    team.valid?
    expect(team.errors[:team]).to include("cannot have more than 6 students")
  end
end
