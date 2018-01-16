class CreateTrades < ActiveRecord::Migration[5.1]
  def change
    create_table :trades do |t|
      t.string :symbol
      t.decimal :count, precision: 15, scale: 7, default: 0
      t.decimal :start_usd, precision: 15, scale: 7
      t.decimal :init_stop_usd, precision: 15, scale: 7
      t.decimal :trailing_stop_usd, precision: 15, scale: 7
      t.decimal :stop_usd, precision: 15, scale: 7
      t.decimal :fees_usd, precision: 15, scale: 7, default: 0
      t.decimal :gain_loss_usd, precision: 15, scale: 7, default: 0
      t.boolean :closed, default: false
      t.datetime :closed_at
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
