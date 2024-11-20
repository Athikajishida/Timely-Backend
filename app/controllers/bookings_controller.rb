# @file BookingsController.rb
# @description Controller for managing bookings in the Timely application. It allows
#              users to create and view their bookings, with checks to avoid duplicate confirmed bookings.
# @version 1.0.0
# @date 2024-11-14
# @authors
#  - Athika Jishida

class BookingsController < ApplicationController # rubocop:disable Style/Documentation
  # Authenticate user before performing any actions in this controller
  before_action :authenticate_user!

  # Set the event object before creating a booking
  before_action :set_event, only: :create

  ##
  # @method create
  # @description Creates a new booking for a specific event. Checks if a confirmed booking already exists for the user and event.
  #              If not, it creates a new confirmed booking.
  # @route POST /bookings
  # @params [Integer] event_id ID of the event for which the booking is created
  # @params [String] scheduled_time Time scheduled for the booking
  # @return [JSON] JSON response with the booking details if successful, or error messages if unsuccessful.
  # @status 201 Created on success, 404 Not Found if the event doesn't exist, or 422 Unprocessable Entity on failure
  def create # rubocop:disable Metrics/MethodLength
    # Ensure event is found
    return render json: { error: 'Event not found' }, status: :not_found unless @event

    # Check for existing confirmed booking for this event
    existing_booking = @event.bookings.find_by(user: current_user, status: 'confirmed')
    if existing_booking
      return render json: { message: 'You already have a confirmed booking for this event', booking: existing_booking },
                    status: :ok
    end

    # Create and confirm a new booking if no existing confirmed booking
    @booking = @event.bookings.build(user: current_user, scheduled_time: params[:scheduled_time])

    if @booking.save
      @booking.update(status: 'confirmed')
      render json: { message: 'Booking confirmed', booking: @booking }, status: :created
    else
      render json: { errors: @booking.errors.full_messages }, status: :unprocessable_entity
    end
  end

  ##
  # @method index
  # @description Fetches and displays all bookings for the current user, along with associated event details.
  # @route GET /bookings
  # @return [JSON] JSON response containing a list of the user's bookings, or an error message on failure.
  # @status 200 OK on success, 500 Internal Server Error on failure
  def index
    @bookings = current_user.bookings.includes(:event)
    render json: @bookings.map { |booking| serialize_booking(booking) }
  rescue StandardError => e
    render json: { error: 'Failed to fetch bookings', details: e.message }, status: :internal_server_error
  end

  private

  ##
  # @method set_event
  # @description Finds and sets the event based on the event_id parameter for booking creation.
  # @return [Event, nil] The event if found, otherwise nil.
  def set_event
    @event = Event.find_by(id: params[:event_id])
  end

  ##
  # @method serialize_booking
  # @description Formats the booking data for JSON response, including event and user details.
  # @param [Booking] booking The booking object to serialize.
  # @return [Hash] A hash containing the formatted booking data.
  def serialize_booking(booking)
    {
      id: booking.id,
      event_id: booking.event_id,
      event_name: booking.event&.name || booking.event&.title,
      scheduled_time: booking.scheduled_time,
      status: booking.status,
      created_at: booking.created_at,
      updated_at: booking.updated_at,
      attendee_name: booking.user&.name,
      duration: booking.event&.duration
    }
  end
end
