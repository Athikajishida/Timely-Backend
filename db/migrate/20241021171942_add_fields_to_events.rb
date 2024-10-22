class AddFieldsToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :title, :string
    add_column :events, :description, :text
    add_column :events, :duration, :integer
    add_column :events, :event_type, :string
    add_column :events, :location, :string
    add_column :events, :max_participants, :integer
    add_column :events, :start_date, :date
    add_column :events, :end_date, :date
    # add_column :events, :start_time, :time
    # add_column :events, :end_time, :time
    add_column :events, :days_available, :jsonb # Using JSONB for daysAvailable object
    add_column :events, :buffer_time, :integer
    add_column :events, :color, :string
  end
end
