class SendEvaluationReminderJob < ApplicationJob
  queue_as :default

  def perform
    tomorrow = Date.tomorrow
    pending_evaluations = Evaluation.joins(:project).where(status: "pending", projects: { due_date: tomorrow })

    pending_evaluations.group_by(&:evaluator_id).each do |id, evaluations|
      NotificationMailer.evaluation_reminder(User.find(id), evaluations).deliver_later
    end
  end
end
