class Booking < ApplicationRecord
  belongs_to :event
  belongs_to :user

  validates :scheduled_time, presence: true
  validate :validate_booking_time

  def validate_booking_time
    if event.bookings.count >= event.quota
      errors.add(:base, "Quota for this event has been reached")
    end
  end
end
