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

ActiveRecord::Schema.define(version: 20161105192155) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "convo_handlers", force: :cascade do |t|
    t.string   "state"
    t.integer  "patient_id"
    t.integer  "log_entry_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "log_entries", force: :cascade do |t|
    t.integer  "day"
    t.text     "food"
    t.boolean  "binge"
    t.boolean  "vomit"
    t.boolean  "laxative"
    t.text     "personal_notes"
    t.string   "time"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "patient_id"
    t.datetime "date"
    t.integer  "convo_handler_id"
    t.text     "location"
  end

  create_table "patients", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "dob"
    t.string   "sex"
    t.float    "diagnosis"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "phone_number"
    t.integer  "convo_handler_id"
    t.integer  "physician_id"
    t.string   "password_digest"
    t.boolean  "archive"
    t.string   "signup_status"
    t.text     "activity_history"
    t.string   "billing_status"
    t.string   "doctor_status"
    t.string   "start_code"
  end

  create_table "physicians", force: :cascade do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "state"
    t.string   "specialty"
    t.integer  "arch_id"
    t.boolean  "archive"
  end

end
