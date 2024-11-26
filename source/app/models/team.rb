class Team < ApplicationRecord
  # Validations
  validates :name, :project_id, presence: true

  # Associations
  belongs_to :project

  has_many :team_memberships, dependent: :destroy
  has_many :students, through: :team_memberships, source: :user

  has_many :evaluations, through: :students, source: :evaluations_as_evaluatee, dependent: :destroy

  def add_student(student)
    if students.size < project.maximum_team_size && !students.exists?(student.id)
      students << student
      create_pending_evaluations_for_new_member(student)
    else
      errors.add(:team, "cannot have more than #{project.maximum_team_size} students")
      false
    end
  end

  def remove_student(student)
    if students.exists?(student.id)
      students.delete(student)
      delete_evaluations_for_member(student)
    else
      errors.add(:team, 'student is not part of this team')
      false
    end
  end

  def joinable?
    students.size < 6
  end

  def members_to_string
    string = ''

    students.each do |student|
      string += "#{student.first_name} #{student.last_name}, "
    end

    string.chomp!(', ') if string.present?
  end

  private

  def create_pending_evaluations_for_new_member(new_member)
    students.each do |existing_member|
      next if existing_member == new_member

      create_evaluation(new_member, existing_member)
      create_evaluation(existing_member, new_member)
    end
  end

  def create_evaluation(evaluator, evaluatee)
    Evaluation.create!(
      evaluator: evaluator,
      evaluatee: evaluatee,
      project: project,
      team: self,
      status: 'pending',
      due_date: project.due_date
    )
  end

  def delete_evaluations_for_member(member)
    evaluations.where(evaluator: member).or(evaluations.where(evaluatee: member)).destroy_all
  end
end
