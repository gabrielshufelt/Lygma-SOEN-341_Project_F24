class Project < ApplicationRecord
  # Validations
  validates :title, :due_date, presence: true

  # Associations
  belongs_to :course
  has_many :teams, dependent: :destroy

  has_many :evaluations, dependent: :destroy # Ensures evaluations related to this project are deleted when the project is deleted
end
