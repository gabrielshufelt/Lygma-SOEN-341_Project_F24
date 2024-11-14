require "test_helper"

# This is the test file for the Course model
class CourseTest < ActiveSupport::TestCase

  # The setup function is called before each test to initialize the @course object
  def setup
    @course = Course.new(
      title: "Software Process",
      code: "SOEN 341"
    )
  end

  # Test that the course is valid with all required attributes
  test "should be valid with all attributes" do
    assert @course.valid?
  end

  # Test that the course is invalid without a title
  test "should be invalid without title" do
    @course.title = nil
    assert_not @course.valid?, "Course should be invalid without a title"
  end

  # Test that the course is invalid without a code
  test "should be invalid without code" do
    @course.code = nil
    assert_not @course.valid?, "Course should be invalid without a code"
  end

  # Test that the course is invalid if the code is not unique
  test "should be invalid with a duplicate code" do
    duplicate_course = @course.dup
    @course.save
    assert_not duplicate_course.valid?, "Course should be invalid with a duplicate code"
  end
end
