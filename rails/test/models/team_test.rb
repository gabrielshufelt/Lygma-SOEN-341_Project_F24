require "test_helper"

# Test file for the Team model
class TeamTest < ActiveSupport::TestCase

  # The setup function is called before each test to initialize the @team object
  def setup
    @instructor = User.create!(name: "Instructor", email: "instructor@example.com")
    @team = Team.new(
      name: "Team Alpha",
      description: "We are so alpha",
      project_id: 1
    )
  end

  # Test that the team is valid with all required attributes
  test "should be valid with all attributes" do
    assert @team.valid?
  end

  # Test that the team is invalid without a name
  test "should be invalid without a name" do
    @team.name = nil
    assert_not @team.valid?, "Team should be invalid without a name"
  end

  # Test that the team is invalid without a project_id
  test "should be invalid without a project_id" do
    @team.project_id = nil
    assert_not @team.valid?, "Team should be invalid without a project_id"
  end

  # Test that the team is invalid without a course_name
  test "should be invalid without course_name" do
    @team.course_name = nil
    assert_not @team.valid?, "Team should be invalid without course_name"
  end

  # Test the custom team size validation
  test "should be invalid if team has more than 6 students" do
    7.times do
      @team.students << User.create!(name: "Student", email: Faker::Internet.email)
    end
    assert_not @team.valid?, "Team should be invalid with more than 6 students"
  end

  # Test that the team has space (fewer than 6 students)
  test "should return true for has_space if team has fewer than 6 students" do
    5.times do
      @team.students << User.create!(name: "Student", email: Faker::Internet.email)
    end
    assert @team.has_space, "Team should have space with fewer than 6 students"
  end

  # Test that the team has no space (6 or more students)
  test "should return false for has_space if team has 6 students" do
    6.times do
      @team.students << User.create!(name: "Student", email: Faker::Internet.email)
    end
    assert_not @team.has_space, "Team should not have space with 6 students"
  end
end
