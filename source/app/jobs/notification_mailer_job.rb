class NotificationMailerJob < ApplicationJob
  queue_as :default

  retry_on StandardError, wait: :exponentially_longer, attempts: 5

  def perform(method_name, *args)
    NotificationMailer.send(method_name, *args).deliver_now
  end
end
