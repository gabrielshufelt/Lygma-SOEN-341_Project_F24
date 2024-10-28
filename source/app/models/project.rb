class Project < ApplicationRecord
  # Validations
  validates :title, :due_date, :course_id, :maximum_team_size, presence: true
  validate :due_date_cannot_be_in_the_past
  validate :maximum_team_size_is_in_range

  # Associations
  belongs_to :course
  has_many :teams, dependent: :destroy

  has_many :evaluations, dependent: :destroy # Ensures evaluations related to this project are deleted when the project is deleted

  def due_date_cannot_be_in_the_past
    errors.add(:due_date, 'cannot be in the past.') if due_date.present? && due_date < Date.today
  end

  def maximum_team_size_is_in_range
    errors.add(:maximum_team_size, 'must be between 0 and 10.') if maximum_team_size < 1 || maximum_team_size > 10
  end
end
