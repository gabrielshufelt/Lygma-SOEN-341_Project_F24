require 'rails_helper'

RSpec.describe User, type: :model do
  let(:student) do
    User.find_or_create_by(id: 0) do |user|
      user.first_name = 'Gab'
      user.last_name = 'Doe'
      user.role = 'student'
      user.email = 'studentttttt@example.com'
      user.password = 'password'
      user.sex = 'male'
      user.student_id = 40_247_001
    end
  end
  let(:instructor) do
    User.find_or_create_by(id: 1) do |user|
      user.first_name = 'John'
      user.last_name = 'Doe'
      user.role = 'instructor'
      user.email = 'instructor@example.com'
      user.password = 'password'
      user.sex = 'male'
    end
  end

  before(:each) do
    student.courses.clear
    Evaluation.delete_all
    Course.delete_all
    User.delete_all
  end

  describe 'student associations' do
    it 'can have many classes' do
      instructor # Ensure the instructor is created
      course1 = Course.find_or_initialize_by(code: 'SOEN 341')
      course1.update!(title: 'Software Process', instructor: instructor)
      course2 = Course.find_or_initialize_by(code: 'ENGR 371')
      course2.update!(title: 'Probability and Statistics', instructor: instructor)
      course3 = Course.find_or_initialize_by(code: 'COMP 352')
      course3.update!(title: 'Data Structures and Algorithms', instructor: instructor)
      student.courses << [course1, course2, course3]
      student.save!
      expect(student.courses.count).to eq(3)
    end
  end

  describe 'student_id validations' do
    it 'is invalid without a unique student_id' do
      User.create!(role: 'student', student_id: 40_247_001, first_name: 'Alice', last_name: 'Smith',
                   email: 'alice@example.com', password: 'password', sex: 'female')
      student2 = User.new(role: 'student', student_id: 40_247_001, first_name: 'Bob', last_name: 'Jones',
                          email: 'bob@example.com', password: 'password', sex: 'male')
      expect(student2).not_to be_valid
    end

    it 'is invalid if student_id is not 8 digits or does not start with 40' do
      invalid_student = User.new(role: 'student', student_id: 4_123_330, first_name: 'Charlie', last_name: 'Brown',
                                 email: 'charlie@example.com', password: 'password', sex: 'male')
      expect(invalid_student).not_to be_valid
    end

    it 'is valid with a correct student_id' do
      valid_student = User.new(role: 'student', student_id: 40_247_005, first_name: 'David', last_name: 'White',
                               email: 'david@example.com', password: 'password', sex: 'male')
      expect(valid_student).to be_valid
    end
  end
end
