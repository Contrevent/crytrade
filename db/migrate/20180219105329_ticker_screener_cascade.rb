class TickerScreenerCascade < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :screener_results, :tickers
    add_foreign_key :screener_results, :tickers, on_delete: :cascade
  end
end
