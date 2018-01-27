class AddSymbolIndex < ActiveRecord::Migration[5.1]
  def change
    add_index(:fiats, :symbol)
    add_index(:ledgers, :symbol)
    add_index(:trades, :sell_symbol)
    add_index(:trades, :buy_symbol)
    add_index(:tickers, :symbol)
    add_index(:tickers, :last_updated)
  end
end
