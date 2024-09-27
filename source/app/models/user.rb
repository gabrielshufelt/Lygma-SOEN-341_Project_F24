class User < ApplicationRecord
  # Associations
  has_many :evaluations_as_evaluatee, foreign_key: "student_id", dependent: :destroy
  belongs_to :team, optional: true
  belongs_to :instructor, class_name: "User", foreign_key: "instructor_id", optional: true

  has_many :projects, foreign_key: "instructor_id", dependent: :destroy  # Instructor oversees multiple projects
  has_many :teams_as_instructor, class_name: "Team", foreign_key: "instructor_id", dependent: :nullify  # Instructor manages multiple teams
  has_many :students, class_name: "User", foreign_key: "instructor_id", dependent: :nullify
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
      if team_id.present?
        errors.add(:team_id, "Must be nil for instructors")
      end
      if cooperation_rating.present? || conceptual_rating.present? || practical_rating.present? || work_ethic_rating.present?
        errors.add(:base, "Instructors cannot have ratings")
      end
      self.team_id = nil
      self.cooperation_rating = nil
      self.conceptual_rating = nil
      self.practical_rating = nil
      self.work_ethic_rating = nil
    end
  end
end
