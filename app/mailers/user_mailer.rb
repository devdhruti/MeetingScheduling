class UserMailer < ApplicationMailer
  default from: 'dhruti3699@gmail.com'

  def welcome_email(email)
    @email = email
    mail(to: @email, subject: 'Meeting creation confirmation')
  end
end