class CreateTickerDays < ActiveRecord::Migration[5.1]
  def change
    create_table :ticker_days do |t|
      t.string :symbol
      t.decimal :min, precision: 15, scale: 7
      t.decimal :max, precision: 15, scale: 7
      t.decimal :price, precision: 15, scale: 7
      t.decimal :vol_24h, precision: 15, scale: 1
      t.datetime :last_ticker_at

      t.timestamps
    end
  end
end
