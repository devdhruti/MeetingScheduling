env :PATH, ENV['PATH']
set :environment, "development"
set :output, "log/cron.log"

every :day, at: ["7:15 PM"] do
  rake 'meeting:send_messages'
end
