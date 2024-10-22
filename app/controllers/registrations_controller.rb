# frozen_string_literal: true

# @file RegistrationsController.rb
# @description Controller for handling user registration and email confirmation in Timely.
# @version 1.0.0.0
# @author - Athika Jishida

class RegistrationsController < ApplicationController
  # Create action for registering a new user or resending OTP for unconfirmed users.
  def create
    existing_user = User.find_by(email: user_params[:email])

    if existing_user
      if existing_user.confirmed
        render json: { error: 'Email already taken' }, status: :unprocessable_entity
      else
        # Resend OTP for unconfirmed user
        existing_user.generate_otp
        existing_user.save
        send_otp_to_user(existing_user)
        render json: { message: 'User already registered but not confirmed. New OTP sent.' }, status: :ok
      end
    else
      user = User.new(user_params)
      if user.save
        send_otp_to_user(user)
        render json: { message: 'User registered. Please check your email for the OTP to confirm your account.' },
               status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  # Action for confirming a user’s email via OTP.
  def confirm_email
    user = User.find_by(email: params[:email])
    if user&.confirm_otp(params[:otp])
      user.confirm! # Mark the user as confirmed
      render json: { message: 'Account confirmed successfully.' }, status: :ok
    else
      render json: { error: 'Invalid or expired OTP.' }, status: :unprocessable_entity
    end
  end

  private

  # @description Strong parameters for user creation.
  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  # @description Sends OTP to the user's email using the mailer.
  def send_otp_to_user(user)
    UserMailer.with(user:, otp: user.confirmation_otp).send_confirmation_email.deliver_now
  end
end
