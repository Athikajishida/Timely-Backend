# frozen_string_literal: true

# @file OtpConfirmationsController.rb
# @description Controller for handling OTP confirmation during email registration for Timely.
# @version 1.0.0
# @authors
#  - Athika Jishida

class OtpConfirmationsController < ApplicationController
  # Create action for verifying OTP for a user and confirming the account
  def create
    user = User.find_by(email: params[:email])
    if user && user.confirmation_otp == params[:otp] && user.otp_valid?
      user.confirm!
      render json: { message: 'Account confirmed successfully.' }, status: :ok
    else
      render json: { error: 'Invalid or expired OTP.' }, status: :unprocessable_entity
    end
  end

  # Confirm action for confirming the OTP and validating the user email.
  def confirm
    user = User.find_by(email: params[:email])
    if user && user.confirmation_otp == params[:otp] && user.otp_valid?
      user.confirm!
      render json: { message: 'Email confirmed successfully.' }, status: :ok
    else
      render json: { error: 'Invalid or expired OTP.' }, status: :unprocessable_entity
    end
  end
end
