class TwilioClient
  attr_reader :client

  def initialize
    @client = Twilio::REST::Client.new account_sid, auth_token
  end

  def send_text(user, message)
    binding.pry
    client.api.account.messages.create(
      to: user.phone,
      from: phone_number,
      body: message
    )
  end

  private

    def account_sid
      Rails.application.secrets.twilio_account_sid
    end

    def auth_token
      Rails.application.secrets.twilio_auth_token
    end

    def phone_number
      Rails.application.secrets.twilio_phone_number
    end
end
