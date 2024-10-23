class EventMailer < ApplicationMailer
  default from: 'no-reply@youreventapp.com'

  def event_invitation
    @event = params[:event]
    mail(
      to: params[:email],
      subject: "You're invited to an event: #{@event.title}"
    )
  end
end
