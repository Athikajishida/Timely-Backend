# frozen_string_literal: true

# @file SessionsController.rb
# @description Controller for managing user sessions in Timely, including login and logout functionality.
# @version 1.0.0
# @authors  - Athika Jishida

class SessionsController < ApplicationController
  # @description Create action for logging in a user by validating credentials.
  skip_before_action :authenticate_user!, only: [:create]

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      if user.confirmed
        token = encode_token({ user_id: user.id })
        render json: { token:, user: user.as_json(only: [:id, :email, :name]) }, status: :ok
      else
        render json: { error: 'Please confirm your email before logging in.' }, status: :forbidden
      end
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end
  # @description Action for logging out the current user.
  # @route DELETE /users/sign_out
  def destroy
    if current_user
      sign_out(current_user)
      render json: { status: { code: 200, message: 'Logged out successfully.' } }, status: :ok
    else
      render json: { status: { code: 401, message: 'User has no active session.' } }, status: :unauthorized
    end
  end

  private

  # @description Encodes the JWT token with a given payload.
  def encode_token(payload)
    JsonWebToken.encode(payload)
  end
end
