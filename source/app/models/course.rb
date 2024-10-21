class Course < ApplicationRecord
  belongs_to :instructor, class_name: 'User', foreign_key: 'instructor_id'

  has_and_belongs_to_many :students, class_name: 'User', join_table: 'course_registrations', dependent: :nullify
  has_many :projects, dependent: :destroy

  validates :title, presence: true
  validates :code, presence: true, uniqueness: true

  def enroll(new_students)
    new_students.each do |student|
      course << student unless students.exists?(student.id)
    end
  end
end
