class User < ApplicationRecord
  # Instructor Associations
  has_many :courses_taught, class_name: 'Course', foreign_key: 'instructor_id'

  # Student Associations
  has_and_belongs_to_many :courses, join_table: 'course_registrations'

  has_many :evaluations_as_evaluatee, class_name: 'Evaluation', foreign_key: 'evaluatee_id', dependent: :destroy
  has_many :evaluations_as_evaluator, class_name: 'Evaluation', foreign_key: 'evaluator_id', dependent: :destroy

  has_many :team_memberships, dependent: :destroy
  has_many :teams, through: :team_memberships

  before_save :validate_role
  before_create :set_default_profile_picture

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Attach profile picture
  has_one_attached :profile_picture

  # Validations
  validates :first_name, :last_name, :sex, presence: true
  validates :role, inclusion: %w[student instructor], presence: true
  validate :validate_role
  validates :profile_picture, content_type: ['image/png', 'image/jpg', 'image/jpeg'],
                              size: { less_than: 2.megabytes,
                                      message: 'is too large. Please select an image under 2 MB.' }
  validate :birth_date_cannot_be_in_the_future # Add custom validation for birth date

  # Validations for student_id
  validates :student_id, uniqueness: true, if: :student?
  validate :valid_student_id, if: :student?

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
    role == 'student'
  end

  def instructor?
    role == 'instructor'
  end

  def validate_role
    return unless instructor?

    if cooperation_rating.present? || conceptual_rating.present? ||
       practical_rating.present? || work_ethic_rating.present?
      errors.add(:base, 'Instructors cannot have ratings')
    end
    self.cooperation_rating = nil
    self.conceptual_rating = nil
    self.practical_rating = nil
    self.work_ethic_rating = nil
  end

  # Add this method
  def enrolled_courses
    student? ? courses : []
  end

  # Custom validation method for birth_date
  def birth_date_cannot_be_in_the_future
    return unless birth_date.present? && birth_date > Date.today

    errors.add(:birth_date, "can't be in the future")
  end

  private

  # Set a default profile picture if none is uploaded
  def set_default_profile_picture
    return if profile_picture.attached?

    profile_picture.attach(io: File.open(Rails.root.join('app/assets/images/default_pfp.png')),
                           filename: 'default_pfp.png', content_type: 'image/png')
  end

  # validation method for student_id
  def valid_student_id
    return if student_id.to_s.match?(/\A40\d{6}\z/)

    errors.add(:student_id, 'must be 8 digits long and start with 40')
  end
end
