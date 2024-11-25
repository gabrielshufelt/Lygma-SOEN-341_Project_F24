class Project < ApplicationRecord
  # Validations
  validates :title, :due_date, :course_id, :maximum_team_size, presence: true
  validate :maximum_team_size_is_in_range
  validate :team_creation_deadline_before_due_date

  # Associations
  belongs_to :course
  has_many :teams, dependent: :destroy

  has_many :evaluations, dependent: :destroy # Ensures evaluations related to this project are deleted when the project is deleted

  def maximum_team_size_is_in_range
    errors.add(:maximum_team_size, 'must be between 0 and 100.') if maximum_team_size < 1 || maximum_team_size > 100
  end

  def team_creation_deadline_before_due_date
    if team_creation_deadline.present? && team_creation_deadline > due_date
      errors.add(:team_creation_deadline, 'must be before the project due date.')
    end
  end
end
