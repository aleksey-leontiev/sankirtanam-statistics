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

ActiveRecord::Schema.define(version: 20141120090320) do

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

end
