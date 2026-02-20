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

ActiveRecord::Schema[7.2].define(version: 2026_02_19_080545) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "consultation_schedules", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "hospital_id", null: false
    t.date "visit_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hospital_id"], name: "index_consultation_schedules_on_hospital_id"
    t.index ["user_id"], name: "index_consultation_schedules_on_user_id"
  end

  create_table "hospital_schedules", force: :cascade do |t|
    t.integer "day_of_week", null: false
    t.integer "period", null: false
    t.time "start_time"
    t.time "end_time"
    t.bigint "hospital_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hospital_id"], name: "index_hospital_schedules_on_hospital_id"
  end

  create_table "hospitals", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "name"], name: "index_hospitals_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_hospitals_on_user_id"
    t.index ["uuid"], name: "index_hospitals_on_uuid", unique: true
  end

  create_table "medicines", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "name"], name: "index_medicines_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_medicines_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "notification_type", null: false
    t.boolean "enabled", default: false, null: false
    t.integer "days_before", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "notification_type"], name: "index_notifications_on_user_id_and_notification_type", unique: true
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "user_medicines", force: :cascade do |t|
    t.integer "prescribed_amount", null: false
    t.integer "current_stock", default: 0, null: false
    t.date "date_of_prescription", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "dosage_per_time", null: false
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.bigint "medicine_id", null: false
    t.integer "times_per_day", default: 1, null: false
    t.index ["medicine_id"], name: "index_user_medicines_on_medicine_id"
    t.index ["user_id", "medicine_id"], name: "index_user_medicines_on_user_id_and_medicine_id", unique: true
    t.index ["user_id"], name: "index_user_medicines_on_user_id"
    t.index ["uuid"], name: "index_user_medicines_on_uuid", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.string "provider"
    t.string "uid"
    t.string "line_user_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["line_user_id"], name: "index_users_on_line_user_id", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uuid"], name: "index_users_on_uuid", unique: true
  end

  add_foreign_key "consultation_schedules", "hospitals"
  add_foreign_key "consultation_schedules", "users"
  add_foreign_key "hospital_schedules", "hospitals"
  add_foreign_key "hospitals", "users"
  add_foreign_key "medicines", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "user_medicines", "medicines"
  add_foreign_key "user_medicines", "users"
end
