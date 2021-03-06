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

ActiveRecord::Schema.define(version: 20170302054547) do

  create_table "brackets", force: :cascade do |t|
    t.integer  "tournament_id"
    t.integer  "user_id"
    t.text     "picks"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "score",         default: 0
  end

  add_index "brackets", ["tournament_id", "user_id"], name: "index_brackets_on_tournament_id_and_user_id", unique: true

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"

  create_table "games", force: :cascade do |t|
    t.integer  "tournament_id"
    t.integer  "team1_id"
    t.integer  "team2_id"
    t.integer  "score1"
    t.integer  "score2"
    t.integer  "position"
    t.datetime "start_time"
    t.boolean  "final",         default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "games", ["tournament_id", "position"], name: "index_games_on_tournament_id_and_position", unique: true

  create_table "teams", force: :cascade do |t|
    t.string   "school"
    t.string   "shortname"
    t.string   "mascot"
    t.integer  "seed"
    t.integer  "region_id"
    t.integer  "espn_id"
    t.integer  "tournament_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "article_url"
    t.text     "preview"
  end

  add_index "teams", ["tournament_id", "region_id", "seed"], name: "index_teams_on_tournament_id_and_region_id_and_seed", unique: true

  create_table "tournaments", force: :cascade do |t|
    t.string   "name"
    t.string   "event"
    t.datetime "start_date"
    t.string   "slug"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "region0"
    t.string   "region1"
    t.string   "region2"
    t.string   "region3"
    t.text     "featured"
    t.boolean  "live",            default: false
    t.text     "challenge_text"
    t.string   "region_sponsor0"
    t.string   "region_sponsor1"
    t.string   "region_sponsor2"
    t.string   "region_sponsor3"
  end

  add_index "tournaments", ["live"], name: "index_tournaments_on_live"
  add_index "tournaments", ["slug"], name: "index_tournaments_on_slug", unique: true

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",     null: false
    t.string   "encrypted_password",     default: "",     null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "facebook_uid"
    t.string   "role",                   default: "user"
    t.string   "google_uid"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
