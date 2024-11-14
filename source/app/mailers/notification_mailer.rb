class NotificationMailer < ApplicationMailer
  include Rails.application.routes.url_helpers
  default from: 'gabshu2014@gmail.com'

  def evaluation_reminder(student, pending_evaluations)
    @student = student
    @pending_evaluations = pending_evaluations

    mail(
      to: @student.email,
      subject: "Reminder: You Have Pending Evaluation(s) Due Tomorrow"
    )
  end
end
