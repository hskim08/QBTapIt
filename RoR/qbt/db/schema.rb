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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130326153946) do

  create_table "songs", :force => true do |t|
    t.string   "title"
    t.string   "artist"
    t.integer  "year"
    t.string   "ground_truth"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "tasks", :force => true do |t|
    t.string   "version_number"
    t.string   "song_title"
    t.string   "user_id"
    t.string   "session_id"
    t.string   "experimenter_id"
    t.string   "tap_data"
    t.string   "tap_y_data"
    t.integer  "with_music"
    t.float    "song_familiarity"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "tap_off_data"
    t.string   "tap_x_data"
    t.integer  "audio_helpful"
    t.integer  "task_order"
    t.string   "device_type"
    t.string   "tap_off_x_data"
    t.string   "tap_off_y_data"
  end

  create_table "users", :force => true do |t|
    t.integer  "age"
    t.string   "gender"
    t.float    "listening_habits"
    t.float    "instrument_training"
    t.float    "theory_training"
    t.string   "handedness"
    t.integer  "tone_deaf"
    t.integer  "arrhythmic"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "user_id"
    t.string   "native_language"
    t.string   "specific_training"
  end

end
