class TeamMembership < ApplicationRecord
  belongs_to :team
  belongs_to :user

  validates :user_id, uniqueness: { scope: :team_id }
  validate :user_must_be_student

  private

  def user_must_be_student
    return if user.role == 'student'

    errors.add(:user, 'must be a student to join a team')
  end
end
