# @file EventsController.rb
# @description Controller for managing events in the Timely application. It handles 
#              event creation, listing all events, and managing participant emails.
# @version 1.0.0
# @date 2024-10-22
# @authors
#  - Athika Jishida
require 'net/http'

class EventsController < ApplicationController
  before_action :authenticate_user!, except: :show_by_token

  before_action :set_event, only: [:update, :destroy]
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
    @event = current_user.events.build(event_params)
    Rails.logger.info("Emails: #{params[:emails]}")

    ActiveRecord::Base.transaction do

      # Generate a unique scheduling link
      @event.scheduling_link = generate_scheduling_link


      # Generate a Google Meet link if the event type is "Google Meet"
      if params[:event_type] == 'Google Meet'
        @event.link = generate_google_meet_link
      elsif params[:event_type] == 'Others'
        @event.link = params[:customlink] 
      end

      if @event.save
        # Handle participant emails if provided
        if params[:emails].present?
          params[:emails].each do |email|
            @event.event_participants.create!(email: email)
            send_event_email(email, @event)
            Rails.logger.info("Sending email to: #{email}")

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
  def show_by_token
    @event = Event.find_by(scheduling_link: params[:token])
    Rails.logger.info "Token received: #{params[:token]}"  # Add this line for debugging

    if @event
      render json: @event
    else
      render json: { error: 'Event not found' }, status: :not_found
    end
  end
  # PUT /events/:id
  def update
    if @event.update(event_params)
      render json: @event, status: :ok
    else
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /events/:id
  def destroy
    participant_emails = @event.event_participants.pluck(:email) # Retrieve participant emails

    if @event.destroy
      # Send email notification to each participant
      participant_emails.each do |email|
        EventMailer.event_deletion_notification(email, @event).deliver_now
      end
      head :no_content
    else
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_event
    @event = Event.find_by(id: params[:id])
  end


  # actual Google API integration)
  def generate_google_meet_link
    "https://meet.google.com/new"
  end
  def generate_scheduling_link
    # Generate a unique token for the scheduling link
    token = SecureRandom.urlsafe_base64(8)

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


    # Map platform and customLink from frontend to backend
    params[:event][:platform] = params[:platform] if params[:platform].present?
    params[:event][:customlink] = params[:customLink] if params[:customLink].present?

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
      :customlink,  
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
