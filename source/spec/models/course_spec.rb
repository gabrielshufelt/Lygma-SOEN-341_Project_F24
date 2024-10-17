require 'rails_helper'

RSpec.describe Course, type: :model do
  let(:course) { Course.new(title: "Software Process", code: "SOEN 341") }

  it "is valid with all attributes" do
    expect(course).to be_valid
  end

  # Test that the course is invalid without a title
  it "is invalid without a title" do
    course.title = nil
    expect(course).to_not be_valid
    expect(course.errors[:title]).to include("can't be blank")
  end

  # Test that the course is invalid without a code
  it "is invalid without a code" do
    course.code = nil
    expect(course).to_not be_valid
    expect(course.errors[:code]).to include("can't be blank")
  end

  # Test that the course is invalid if the code is not unique
  it "is invalid with a duplicate code" do
    course.save
    duplicate_course = Course.new(title: "Software Engineering", code: "SOEN 341")
    expect(duplicate_course).to_not be_valid
    expect(duplicate_course.errors[:code]).to include("has already been taken")
  end
end
