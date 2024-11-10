# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer_mailer
class NotificationMailerPreview < ActionMailer::Preview
  def evaluation_reminder
    student = User.first
    pending_evaluations = Evaluation.where(status: 'pending').limit(3) # Sample data for pending evaluations

    NotificationMailer.evaluation_reminder(student, pending_evaluations)
  end
end

