class Project < ApplicationRecord
  # Validations
  validates :title, :team_id, :due_date, :instructor_id, presence: true

  # Associations
  belongs_to :team
  belongs_to :instructor, class_name: "User"
  has_many :evaluations, dependent: :destroy # Ensures evaluations related to this project are deleted when the project is deleted
  has_many :students, through: :team
end
