require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  test "should not save project without title, due_date, team_id, and instructor_id" do
    project = Project.new
    assert_not project.save, "Saved the project without required fields"
  end

  test "should save project with all required fields" do
    project = Project.new(title: "New Project", due_date: Date.today, team_id: 1, instructor_id: 1)
    assert project.save, "Failed to save the project with required fields"
  end
end
