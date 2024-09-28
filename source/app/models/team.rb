class Team < ApplicationRecord
  # Validations
  validates :name, :instructor_id, :course_name, presence: true
  validate :validate_team_size

  # Associations
  has_many :students, class_name: "User", foreign_key: "team_id", dependent: :nullify
  belongs_to :instructor, class_name: "User", foreign_key: "instructor_id"
  has_many :projects, dependent: :destroy
  has_many :evaluations, through: :students, source: :evaluations_as_evaluatee


  def validate_team_size
    if students.count > 6
      errors.add(:team, "cannot have more than 6 students")
    end
  end
end
