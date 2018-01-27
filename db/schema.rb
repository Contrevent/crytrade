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

ActiveRecord::Schema.define(version: 20180127174505) do

  create_table "fiats", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "symbol"
    t.decimal "price_usd", precision: 15, scale: 7
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["symbol"], name: "index_fiats_on_symbol"
  end

  create_table "ledgers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.decimal "count", precision: 15, scale: 7, default: "0.0"
    t.string "symbol"
    t.bigint "trade_id"
    t.bigint "user_id"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["symbol"], name: "index_ledgers_on_symbol"
    t.index ["trade_id"], name: "index_ledgers_on_trade_id"
    t.index ["user_id"], name: "index_ledgers_on_user_id"
  end

  create_table "screener_filters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "screener_id"
    t.string "field"
    t.string "type"
    t.string "operator"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["screener_id"], name: "index_screener_filters_on_screener_id"
  end

  create_table "screener_jobs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "screener_id"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["screener_id"], name: "index_screener_jobs_on_screener_id"
  end

  create_table "screener_results", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "screener_job_id"
    t.bigint "ticker_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["screener_job_id"], name: "index_screener_results_on_screener_job_id"
    t.index ["ticker_id"], name: "index_screener_results_on_ticker_id"
  end

  create_table "screeners", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.string "name"
    t.datetime "last_run_at"
    t.integer "last_run_count"
    t.integer "last_job_id", default: -1
    t.boolean "refresh", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_screeners_on_user_id"
  end

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
    t.index ["last_updated"], name: "index_tickers_on_last_updated"
    t.index ["symbol"], name: "index_tickers_on_symbol"
  end

  create_table "tiles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.string "kind"
    t.integer "ref_id"
    t.integer "width"
    t.integer "height"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tiles_on_user_id"
  end

  create_table "trades", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "sell_symbol"
    t.string "buy_symbol"
    t.decimal "count", precision: 15, scale: 7, default: "0.0"
    t.decimal "sell_start_usd", precision: 15, scale: 7
    t.decimal "start_usd", precision: 15, scale: 7
    t.decimal "init_stop_usd", precision: 15, scale: 7
    t.decimal "trailing_stop_usd", precision: 15, scale: 7
    t.decimal "sell_stop_usd", precision: 15, scale: 7
    t.decimal "stop_usd", precision: 15, scale: 7
    t.decimal "fees_usd", precision: 15, scale: 7, default: "0.0"
    t.decimal "gain_loss_usd", precision: 15, scale: 7, default: "0.0"
    t.boolean "closed", default: false
    t.datetime "closed_at"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buy_symbol"], name: "index_trades_on_buy_symbol"
    t.index ["sell_symbol"], name: "index_trades_on_sell_symbol"
    t.index ["user_id"], name: "index_trades_on_user_id"
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
    t.string "reference_symbol", default: "USD"
    t.string "reference_character", default: "$"
    t.integer "reference_precision", default: 2
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "ledgers", "trades"
  add_foreign_key "ledgers", "users"
  add_foreign_key "screener_filters", "screeners"
  add_foreign_key "screener_jobs", "screeners"
  add_foreign_key "screener_results", "screener_jobs"
  add_foreign_key "screener_results", "tickers"
  add_foreign_key "screeners", "users"
  add_foreign_key "tiles", "users"
  add_foreign_key "trades", "users"
end
