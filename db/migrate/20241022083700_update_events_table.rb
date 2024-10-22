class UpdateEventsTable < ActiveRecord::Migration[7.0]
  def change
  

    # Adding necessary fields (if not already in the table)
    change_table :events do |t|
      # t.references :user, null: false, foreign_key: true
      # t.string :title, null: false
      # t.text :description
      # t.string :event_type, null: false
      # t.string :location, null: false
      # t.date :start_date, null: false
      # t.date :end_date, null: false
      # t.time :start_time, null: false
      # t.time :end_time, null: false
      # t.integer :buffer_time
      # t.string :color
      # t.jsonb :days_available, default: {
      #   monday: true,
      #   tuesday: true,
      #   wednesday: true,
      #   thursday: true,
      #   friday: true,
      #   saturday: false,
      #   sunday: false
      # }
    end
  end
end
