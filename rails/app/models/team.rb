class Team < ApplicationRecord
  # Validations
  validates :name, :project_id, presence: true

  # Associations
  belongs_to :project

  has_many :team_memberships, dependent: :destroy
  has_many :students, through: :team_memberships, source: :user
  
  has_many :evaluations, through: :students, source: :evaluations_as_evaluatee, dependent: :destroy

  def add_student(student)
    if students.size < 6
      students << student
    else
      errors.add(:team, "cannot have more than 6 students")
      false
    end
  end

  def remove_student(student)
    if students.exists?(student.id)
      students.delete(student)
    else
      errors.add(:team, "student is not part of this team")
      false
    end
  end

  def has_space
    students.size < 6
  end
end
