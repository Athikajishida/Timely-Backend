# frozen_string_literal: true

class UserMailer < ApplicationMailer
  default from: 'no-reply@timely.com'

  def send_confirmation_email
    @user = params[:user]
    @otp = params[:otp]
    mail(to: @user.email, subject: 'Confirm Your Email with OTP')
  end
end
