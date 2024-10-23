# app/models/event.rb
class Event < ApplicationRecord
  belongs_to :user
  has_many :event_participants, dependent: :destroy
  has_many :bookings, dependent: :destroy

  validates :title, presence: true
  validates :event_type, presence: true
  # validates :location, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :days_available, presence: true
  validates :buffer_time, presence: true
  
  # Optional but recommended validations
  validate :end_date_after_start_date
  validate :end_time_after_start_time
  enum platform: {  google_meet: "1", zoom: "2", others: "3" }

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?
    
    if end_date < start_date
      errors.add(:end_date, "must be after start date")
    end
  end

  def end_time_after_start_time
    return if end_time.blank? || start_time.blank?
    
    if end_time < start_time
      errors.add(:end_time, "must be after start time")
    end
  end
end