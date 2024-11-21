class AdminController < ApplicationController
  before_action :authenticate_admin!
  
  def users
    @users = User.all
    render json: @users
  end

  def events
    @events = Event.includes(:user).all
    render json: @events, include: :user
  end

  def bookings
    @bookings = Booking.includes(:user, :event).all
    render json: @bookings, include: [:user, :event]
  end

  def block_user
    @user = User.find(params[:id])
    @user.update(confirmed: false)
    render json: @user
  end

  def unblock_user
    @user = User.find(params[:id])
    @user.update(confirmed: true)
    render json: @user
  end

  def cancel_event
    @event = Event.find(params[:id])
    # Cancel all related bookings
    @event.bookings.update_all(status: 'cancelled')
    render json: @event
  end

  def update_event
    @event = Event.find(params[:id])
    if @event.update(event_params)
      render json: @event
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  private

  def authenticate_admin!
    # Implement your admin authentication logic here
    # For example:
    unless current_user&.admin?
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def event_params
    params.require(:event).permit(
      :name, 
      :title, 
      :description, 
      :event_type, 
      :duration, 
      :location, 
      :max_participants, 
      :start_date, 
      :end_date, 
      :days_available, 
      :buffer_time, 
      :color, 
      :link, 
      :platform, 
      :customlink, 
      :scheduling_link
    )
  end
end