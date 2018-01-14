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

ActiveRecord::Schema.define(version: 20180114093949) do

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

end
