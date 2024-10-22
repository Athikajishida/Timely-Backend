# frozen_string_literal: true

class AddOtpFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :confirmation_otp, :string
    add_column :users, :confirmation_otp_sent_at, :datetime
    add_column :users, :confirmed, :boolean
  end
end
