class User < ApplicationRecord
  # Instructor Associations
  has_many :courses_taught, class_name: 'Course', foreign_key: 'instructor_id'
  has_many :projects, foreign_key: "instructor_id", dependent: :destroy  # Instructor oversees multiple projects
  has_many :teams_as_instructor, class_name: "Team", foreign_key: "instructor_id", dependent: :nullify  # Instructor manages multiple teams

  # Student Associations
  has_and_belongs_to_many :courses, join_table: 'course_registrations'
  belongs_to :team, optional: true
  has_many :evaluations_as_evaluatee, class_name: "Evaluation", foreign_key: "student_id", dependent: :destroy
  
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
