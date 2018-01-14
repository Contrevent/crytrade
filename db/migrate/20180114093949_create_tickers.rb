class CreateTickers < ActiveRecord::Migration[5.1]
  def change
    create_table :tickers do |t|
      t.string :currency_id
      t.string :currency_name
      t.string :symbol
      t.integer :rank
      t.decimal :price_usd, precision: 15, scale:7
      t.decimal :price_btc, precision: 15, scale:12
      t.decimal :volume_usd_24h, precision: 15, scale:1
      t.decimal :market_cap_usd, precision: 15, scale:1
      t.decimal :available_supply, precision: 15, scale:0
      t.decimal :total_supply, precision: 15, scale:0
      t.decimal :max_supply, precision: 15, scale:0
      t.decimal :percent_change_1h, precision: 8, scale:3
      t.decimal :percent_change_24h, precision: 8, scale:3
      t.decimal :percent_change_7d, precision: 8, scale:3
      t.integer :last_updated

      t.timestamps
    end
  end
end
