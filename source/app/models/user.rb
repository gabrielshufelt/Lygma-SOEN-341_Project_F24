class User < ApplicationRecord
  before_save :validate_role

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, presence: true
  validates :role, inclusion: ["student", "instructor"], presence: true

  def student?
    role == "student"
  end

  def instructor?
    role == "instructor"
  end

  def validate_role
    if instructor?      # instructors cannot belong to a team, nor have a rating
      self.team_id = nil
      self.cooperation_rating = nil
      self.conceptual_rating = nil
      self.practical_rating = nil
      self.work_ethic_rating = nil
    end
  end
end
