# frozen_string_literal: true

class RegistrationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create, :confirm_email]

  def create
    existing_user = User.find_by(email: user_params[:email])

    if existing_user
      handle_existing_user(existing_user)
    else
      create_new_user
    end
  end

  def confirm_email
    user = User.find_by(email: params[:email])

    if !user
      render json: { error: 'User not found' }, status: :not_found
      return
    end

    if user.confirmed
      render json: { error: 'Email already confirmed' }, status: :unprocessable_entity
      return
    end

    if user&.confirm_otp(params[:otp])
      user.confirm!
      token = encode_token(user)

      render json: {
        message: 'Account confirmed successfully.',
        token: token,
        user: user.as_json(only: [:id, :name, :email])
      }, status: :ok
    else
      render json: { 
        error: 'Invalid or expired OTP.',
        message: 'Please check the OTP and try again. You can request a new OTP if needed.'
      }, status: :unprocessable_entity
    end
  end

  private

  def handle_existing_user(user)
    if user.confirmed
      render json: { error: 'Email already taken' }, status: :unprocessable_entity
    else
      resend_otp(user)
    end
  end

  def create_new_user
    user = User.new(user_params)
    if user.save
      send_otp_to_user(user)
      render json: {
        message: 'User registered. Please check your email for the OTP to confirm your account.',
        email: user.email
      }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def resend_otp(user)
    user.generate_otp
    if user.save
      send_otp_to_user(user)
      render json: { 
        message: 'User already registered but not confirmed. New OTP sent.',
        email: user.email
      }, status: :ok
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def encode_token(user)
    payload = { 
      user_id: user.id, 
      email: user.email,
      exp: 24.hours.from_now.to_i
    }
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def send_otp_to_user(user)
    UserMailer.with(user: user, otp: user.confirmation_otp)
            .send_confirmation_email
            .deliver_now
  end
end