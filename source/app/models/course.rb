class Course < ApplicationRecord
  belongs_to :instructor, class_name: 'User', foreign_key: 'instructor_id'
  has_and_belongs_to_many :students, class_name: 'User', join_table: 'course_registrations'
  has_many :projects

  validates :title, presence: true
  validates :code, presence: true, uniqueness: true
end
