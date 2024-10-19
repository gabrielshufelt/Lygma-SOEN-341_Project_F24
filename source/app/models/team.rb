class Team < ApplicationRecord
  # Validations
  validates :name, :project_id, presence: true
  validate :validate_team_size

  # Associations
  belongs_to :project

  has_many :team_memberships, dependent: :destroy
  has_many :students, through: :team_memberships, source: :user
  
  has_many :evaluations, through: :students, source: :evaluations_as_evaluatee, dependent: :destroy

  def validate_team_size
    if students.count > 6
      errors.add(:team, "cannot have more than 6 students")
    end
  end

  def has_space
    students.count < 6
  end
end
