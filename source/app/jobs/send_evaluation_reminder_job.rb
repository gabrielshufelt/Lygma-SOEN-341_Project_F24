class SendEvaluationReminderJob < ApplicationJob
  queue_as :default

  def perform
    tomorrow = Date.tomorrow
    pending_evaluations = Evaluation.joins(:project).where(status: "pending", projects: { due_date: tomorrow })

    pending_evaluations.group_by(&:evaluator_id).each do |id, evaluations|
      begin
        NotificationMailer.evaluation_reminder(User.find(id), evaluations.to_a).deliver_later
      rescue => e
        Rails.logger.error "Failed to send reminder email to User #{id}: #{e.message}"
      end
    end
  end
end
