# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141121080228) do

  create_table "events", force: true do |t|
    t.string "name"
    t.string "url"
    t.date   "start_date"
  end

  create_table "locations", force: true do |t|
    t.string "name"
    t.string "url"
  end

  create_table "people", force: true do |t|
    t.string  "name"
    t.integer "location_id"
  end

  add_index "people", ["location_id"], name: "index_people_on_location_id"

  create_table "record_types", force: true do |t|
    t.string "name"
  end

  create_table "records", force: true do |t|
    t.integer "type_id"
    t.integer "report_id"
    t.integer "person_id"
    t.string  "value"
    t.integer "day"
  end

  add_index "records", ["person_id"], name: "index_records_on_person_id"
  add_index "records", ["report_id"], name: "index_records_on_report_id"
  add_index "records", ["type_id"], name: "index_records_on_type_id"

  create_table "reports", force: true do |t|
    t.integer "location_id"
    t.integer "event_id"
    t.integer "year"
    t.integer "month"
    t.integer "day"
  end

  add_index "reports", ["event_id"], name: "index_reports_on_event_id"
  add_index "reports", ["location_id"], name: "index_reports_on_location_id"

  create_table "user_location_accesses", force: true do |t|
    t.integer "user_id"
    t.integer "location_id"
  end

  add_index "user_location_accesses", ["location_id"], name: "index_user_location_accesses_on_location_id"
  add_index "user_location_accesses", ["user_id"], name: "index_user_location_accesses_on_user_id"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
