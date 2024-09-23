class Evaluation < ApplicationRecord
    validates :status, :date_completed, :project_id, :student_id, :cooperation_rating, :conceptual_rating, :practical_rating, :work_ethic_rating, presence: true
end
