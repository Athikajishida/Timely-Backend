# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate_user!
  
  # Method to authenticate the user with a JWT token
  def authenticate_user!
    header = request.headers['Authorization']
    token = header.split(' ').last if header.present?
    
    begin
      @decoded = JsonWebToken.decode(token)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end


  # Current user method
  def current_user
    @current_user
  end
end
