class Project < ApplicationRecord
  # Validations
  validates :title, presence: true
  validates :team_id, presence: true
  validates :due_date, presence: true
  validates :instructor_id, presence: true

  # TODO: creating associations for team and instructor models (Do the same in team and instructor models as well)
  # belongs_to: team
  # belongs_to: instructor
end
