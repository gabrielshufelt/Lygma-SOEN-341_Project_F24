require 'rails_helper'

RSpec.describe Course, type: :model do
  let(:instructor) do
    User.find_or_create_by(email: 'john.daquavious@example.com') do |user|
      user.first_name = 'John'
      user.last_name = 'Daquavious'
      user.role = 'instructor'
      user.password = 'password'
      user.sex = 'male'
    end
  end

  let(:course) { Course.find_or_initialize_by(code: 'SOEN 341') }

  before(:each) do
    instructor # Ensure the instructor is created
  end

  it 'is valid with all attributes' do
    course.update!(title: 'Software Process', instructor: instructor)
    expect(course).to be_valid
  end

  it 'is invalid without a title' do
    course.update!(title: 'Software Process', instructor: instructor)
    course.title = nil
    expect(course).to_not be_valid
    expect(course.errors[:title]).to include("can't be blank")
  end

  it 'is invalid without a code' do
    course.update!(title: 'Software Process', instructor: instructor)
    course.code = nil
    expect(course).to_not be_valid
    expect(course.errors[:code]).to include("can't be blank")
  end

  it 'is invalid with a duplicate code' do
    course.update!(title: 'Software Process', instructor: instructor)
    course.save
    duplicate_course = Course.new(title: 'Software Engineering', code: 'SOEN 341', instructor: instructor)
    expect(duplicate_course).to_not be_valid
    expect(duplicate_course.errors[:code]).to include('has already been taken')
  end

  it 'is associated to a unique instructor' do
    course.update!(title: 'Software Process', instructor: instructor)
    expect(course.instructor.first_name).to eq('John')
  end
end
