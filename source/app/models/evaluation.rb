class Evaluation < ApplicationRecord
    # Validations
    validates :status, :project_id, :evaluatee_id, :evaluator_id, presence: true
    validate :completed_date_cannot_be_in_the_future
    validate :evaluator_cannot_be_evaluatee

    # Associations
    belongs_to :evaluator, class_name: "User"
    belongs_to :evaluatee, class_name: "User"
    belongs_to :project
    belongs_to :team

    # Callbacks
    after_update :send_email_on_completed, if: -> { status == 'completed' }
    before_save :set_status_and_date

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

    private

    # Automatically set status and date based on ratings
    def set_status_and_date
        if cooperation_rating.present? && conceptual_rating.present? && practical_rating.present? && work_ethic_rating.present?
            self.status = 'completed'
            self.date_completed ||= Date.today # Only set date_completed if it hasn't been set yet
        else
            self.status = 'pending'
            self.date_completed = nil
        end
    end

    def send_email_on_completed
        NotificationMailer.new_evaluation_for_student(evaluatee, self).deliver_later
    end
end
