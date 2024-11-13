class BookingsController < ApplicationController
  before_action :authenticate_user!

  def create
    @event = Event.find(params[:event_id])
    @booking = @event.bookings.build(user: current_user, scheduled_time: params[:scheduled_time])

    if @booking.save
      @booking.update(status: 'confirmed')
      render json: { message: 'Booking confirmed', booking: @booking }, status: :created
    else
      render json: { errors: @booking.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    @bookings = current_user.bookings
    render json: @bookings
  end
end
