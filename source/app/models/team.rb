class Team < ApplicationRecord
  # Validations
  validates :name, :project_id, presence: true

  # Associations
  belongs_to :project

  has_many :team_memberships, dependent: :destroy
  has_many :students, through: :team_memberships, source: :user

  has_many :evaluations, through: :students, source: :evaluations_as_evaluatee, dependent: :destroy

  def add_student(student)
    if students.size < project.maximum_team_size && !students.exists?(student.id)
      students << student
    else
      errors.add(:team, "cannot have more than #{project.maximum_team_size} students")
      false
    end
  end

  def remove_student(student)
    if students.exists?(student.id)
      students.delete(student)
    else
      errors.add(:team, 'student is not part of this team')
      false
    end
  end

  def has_space
    students.size < 6
  end

  def members_to_string
    string = ''

    students.each do |student|
      string += "#{student.first_name} #{student.last_name}, "
    end

    string.chomp!(', ') if string.present?
  end
end
