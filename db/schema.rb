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

ActiveRecord::Schema.define(version: 20180115082419) do

  create_table "tickers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "currency_id"
    t.string "currency_name"
    t.string "symbol"
    t.integer "rank"
    t.decimal "price_usd", precision: 15, scale: 7
    t.decimal "price_btc", precision: 15, scale: 12
    t.decimal "volume_usd_24h", precision: 15, scale: 1
    t.decimal "market_cap_usd", precision: 15, scale: 1
    t.decimal "available_supply", precision: 15
    t.decimal "total_supply", precision: 15
    t.decimal "max_supply", precision: 15
    t.decimal "percent_change_1h", precision: 8, scale: 3
    t.decimal "percent_change_24h", precision: 8, scale: 3
    t.decimal "percent_change_7d", precision: 8, scale: 3
    t.integer "last_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
