ActiveRecord::Schema[7.1].define(version: 2024_10_22_083700) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "user_id", null: false
    t.datetime "scheduled_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_bookings_on_event_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "event_participants", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id", "email"], name: "index_event_participants_on_event_id_and_email", unique: true
    t.index ["event_id"], name: "index_event_participants_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.integer "quota"
    t.datetime "start_time"
    t.datetime "end_time"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.text "description"
    t.integer "duration"
    t.string "event_type"
    t.string "location"
    t.integer "max_participants"
    t.date "start_date"
    t.date "end_date"
    t.jsonb "days_available"
    t.integer "buffer_time"
    t.string "color"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phonenumber"
    t.string "confirmation_otp"
    t.datetime "confirmation_otp_sent_at"
    t.boolean "confirmed"
  end

  add_foreign_key "bookings", "events"
  add_foreign_key "bookings", "users"
  add_foreign_key "event_participants", "events"
  add_foreign_key "events", "users"
end
