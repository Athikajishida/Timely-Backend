# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_11_12_163307) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "user_id", null: false
    t.datetime "scheduled_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "pending"
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
    t.string "link"
    t.integer "platform", default: 0, null: false
    t.string "customlink"
    t.string "scheduling_link"
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
