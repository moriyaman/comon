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

ActiveRecord::Schema.define(version: 20140716233558) do

  create_table "event_participants", force: true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.boolean  "lt_flg",     default: false
    t.boolean  "cancel_flg", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.string   "title"
    t.string   "address"
    t.string   "url"
    t.text     "description", limit: 16777215
    t.datetime "started_at"
    t.datetime "ended_at"
    t.integer  "limit"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["ended_at"], name: "index_events_on_ended_at", using: :btree
  add_index "events", ["started_at"], name: "index_events_on_started_at", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "facebook"
    t.string   "twitter"
    t.string   "github"
    t.string   "connpass_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "linkedin"
    t.float    "qiita_rank"
    t.float    "github_rank"
  end

  add_index "users", ["connpass_url"], name: "index_users_on_connpass_url", using: :btree
  add_index "users", ["github_rank"], name: "index_users_on_github_rank", using: :btree
  add_index "users", ["linkedin"], name: "index_users_on_linkedin", using: :btree
  add_index "users", ["qiita_rank"], name: "index_users_on_qiita_rank", using: :btree

end
