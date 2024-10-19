class User < ApplicationRecord
  # Instructor Associations
  has_many :courses_taught, class_name: 'Course', foreign_key: 'instructor_id'

  # Student Associations
  has_and_belongs_to_many :courses, join_table: 'course_registrations'
  
  has_many :evaluations_as_evaluatee, class_name: "Evaluation", foreign_key: "evaluatee_id", dependent: :destroy
  has_many :evaluations_as_evaluator, class_name: "Evaluation", foreign_key: "evaluator_id", dependent: :destroy
  
  has_many :team_memberships, dependent: :destroy
  has_many :teams, through: :team_memberships
  
  before_save :validate_role

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Validations
  validates :first_name, :last_name, :sex, presence: true
  validates :role, inclusion: ["student", "instructor"], presence: true
  validate :validate_role

  def honorifics
    case sex
    when 'male'
      'Mr.'
    when 'female'
      'Ms.'
    when 'other'
      'Mx.'
    else
      '' 
    end
  end


  def student?
    role == "student"
  end

  def instructor?
    role == "instructor"
  end

  def validate_role
    if instructor?
      if cooperation_rating.present? || conceptual_rating.present? || practical_rating.present? || work_ethic_rating.present?
        errors.add(:base, "Instructors cannot have ratings")
      end
      self.cooperation_rating = nil
      self.conceptual_rating = nil
      self.practical_rating = nil
      self.work_ethic_rating = nil
    end
  end
end
