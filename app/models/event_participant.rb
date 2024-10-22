# app/models/event_participant.rb
class EventParticipant < ApplicationRecord
  belongs_to :event

  validates :email, presence: true
  validates :event_id, uniqueness: { scope: :email }
end