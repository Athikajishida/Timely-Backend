# frozen_string_literal: true

# @file UsersController.rb
# @description Controller for managing user profiles in Timely, including viewing and updating user information.
# @version 1.0.0 (Initial implementation with profile viewing and updating)
# @authors
#  - Athika Jishida

class UsersController < ApplicationController
  before_action :authorized, only: %i[update show]

  # @description Action for displaying a user's profile based on the user ID.
  def show
    user = User.find(params[:id])
    render json: user
  end

  # @description Action for updating a user's profile information.
  def update
    user = User.find(params[:id])
    if user.update(user_params)
      render json: user
    else
      render json: { error: 'Failed to update profile' }, status: :unprocessable_entity
    end
  end

  private

  # @description Strong parameters for user updates.
  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  # @description Authorization logic to ensure the user is authenticated.
  def authorized
    # Authorization logic using JWT
  end
end
