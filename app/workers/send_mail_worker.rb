class SendMailWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(email, count)
    puts "Mail sent successfully"
    UserMailer.welcome_email(email).deliver
  end
end
