require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  test 'should not save project without title, due_date, and course_id' do
    project = Project.new
    assert_not project.save, 'Saved the project without required fields'
  end

  test 'should save project with all required fields' do
    project = Project.new(title: 'New Project', due_date: Date.today, course_id: 1)
    assert project.save, 'Failed to save the project with required fields'
  end
end
