class Evaluation < ApplicationRecord
    # Validations
    validates :status, :date_completed, :project_id, :student_id, :cooperation_rating, :conceptual_rating, :practical_rating, :work_ethic_rating, presence: true
    validate :completed_date_cannot_be_in_the_future

    # Associations
    belongs_to :project
    belongs_to :student, class_name: "User"

    # Custom validation for date_completed
    def completed_date_cannot_be_in_the_future
        if date_completed.present? && date_completed > Date.today
        errors.add(:date_completed, "cannot be in the future")
        end
    end
end
