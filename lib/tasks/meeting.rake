namespace :meeting do
  desc "TODO"
  task send_messages: :environment do
    SendMessage.new.perform
  end
end
