# frozen_string_literal: true
class SendMessage
  def perform
    if Meeting.tomorrow_meeting.present?
      Meeting.tomorrow_meeting.each do |meeting|
        message = "Hey, #{meeting.user.email}, we’re eagerly waiting to see to at the meeting #{meeting.title}, tomorrow at #{meeting.start_time.strftime("%I:%M%p")}"
        TwilioClient.new.send_text(meeting.user, message)
      end
    end
  end
  handle_asynchronously :perform
end
