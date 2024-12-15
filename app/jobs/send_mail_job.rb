class SendMailJob < ApplicationJob
  queue_as :default

  def perform user = nil
    Rails.logger.info "Sending mail job start:"
    UserMailer.account_activation(user).deliver_now
  end
end
