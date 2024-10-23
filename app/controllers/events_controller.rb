# @file EventsController.rb
# @description Controller for managing events in the Timely application. It handles 
#              event creation, listing all events, and managing participant emails.
# @version 1.0.0
# @date 2024-10-22
# @authors
#  - Athika Jishida
require 'net/http'

class EventsController < ApplicationController

  # @description Retrieves all events from the database and renders them as JSON.
  # @route GET /events
  def index
    @events = Event.all
    render json: @events
  end

  # @description Creates a new event for the current user. This action also processes
  #              participant emails if they are provided in the request parameters.
  # @route POST /events
  def create
    # binding.pry
    @event = current_user.events.build(event_params)

    ActiveRecord::Base.transaction do
      # Generate a Google Meet link if the event type is "Google Meet"
      if params[:event_type] == 'Google Meet'
        @event.link = generate_google_meet_link
      end

      if @event.save
        # Handle participant emails if provided
        if params[:emails].present?
          params[:emails].each do |email|
            @event.event_participants.create!(email: email)
            send_event_email(email, @event)
          end
        end
        render json: @event, status: :created
      else
        render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.message }, status: :unprocessable_entity
  end


  private
  # actual Google API integration)
  def generate_google_meet_link
    "https://meet.google.com/new"
  end

  # Sends an email with event details
  def send_event_email(email, event)
    EventMailer.with(email: email, event: event).event_invitation.deliver_now
  end

  # @description Strong parameter method to sanitize input and convert necessary fields. 
  #              Handles conversion of date and time fields and renames `type` to `event_type`.
  # @return [ActionController::Parameters] Permitted parameters for event creation
  def event_params
    # Convert dateRange and timeRange parameters
    if params[:dateRange].present?
      params[:event][:start_date] = params[:dateRange][:startDate]
      params[:event][:end_date] = params[:dateRange][:endDate]
    end
    if params[:timeRange].present?
      params[:event][:start_time] = params[:timeRange][:startTime]
      params[:event][:end_time] = params[:timeRange][:endTime]
    end

    # Convert bufferTime to an integer
    params[:event][:buffer_time] = params[:bufferTime].to_i if params[:bufferTime].present?

    # Rename `type` to `event_type`
    params[:event][:event_type] = params[:type] if params[:type].present?

    # Merge daysAvailable into the event parameters
    if params[:daysAvailable].present?
      params[:event][:days_available] = params[:daysAvailable]
    end

    # Permit the necessary parameters
    params.require(:event).permit(
      :title,
      :description,
      :event_type,
      :platform,
       :customLink,
      :start_date,
      :end_date,
      :start_time,
      :end_time,
      :buffer_time,
      :color,
      :link,
      days_available: {}
    )
  end
end
