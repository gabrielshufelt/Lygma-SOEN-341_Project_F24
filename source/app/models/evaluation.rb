class Evaluation < ApplicationRecord
    # Validations
    validates :status, :date_completed, :project_id, :evaluatee_id, :evaluator_id, :cooperation_rating, :conceptual_rating, :practical_rating, :work_ethic_rating, presence: true
    validate :completed_date_cannot_be_in_the_future
    validate :evaluator_cannot_be_evaluatee

    # Associations
    belongs_to :evaluator, class_name: "User"
    belongs_to :evaluatee, class_name: "User"
    belongs_to :project
    belongs_to :team

    # Custom validation for date_completed
    def completed_date_cannot_be_in_the_future
        if date_completed.present? && date_completed > Date.today
        errors.add(:date_completed, "cannot be in the future")
        end
    end

    def evaluator_cannot_be_evaluatee
        if evaluator == evaluatee
            errors.add(:evaluator, "cannot be evaluatee")
        end
    end
end
