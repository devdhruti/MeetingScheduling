namespace :meeting do
  desc "Send Message"
  task send_messages: :environment do
    SendMessage.new.perform
  end
end
