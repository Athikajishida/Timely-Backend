class AddStatusToBookings < ActiveRecord::Migration[7.1] # rubocop:disable Style/Documentation
  def change
    add_column :bookings, :status, :string, default: 'pending'
  end
end
