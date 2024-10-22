# frozen_string_literal: true

# @file User.rb
# @description Model for managing user data and authentication in Timely, including OTP generation and confirmation.
# @version 1.0.0
# @authors - Athika Jishida

class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  has_many :events
  before_create :generate_otp

  # Generate OTP and store it in the database along with the sent timestamp
  def generate_otp
    self.confirmation_otp = rand(100_000..999_999).to_s
    self.confirmation_otp_sent_at = Time.current
  end

  # Check if the provided OTP is valid
  def confirm_otp(otp)
    return false if confirmation_otp != otp
    return false if confirmation_otp_sent_at < 10.minutes.ago

    true
  end

  # Mark the user as confirmed
  def confirm!
    update(confirmed: true, confirmation_otp: nil, confirmation_otp_sent_at: nil)
  end

  # Check if OTP is still valid (within 10 minutes)
  def otp_valid?
    confirmation_otp_sent_at && confirmation_otp_sent_at > 10.minutes.ago
  end
end
