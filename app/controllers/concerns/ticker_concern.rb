module TickerConcern
  extend ActiveSupport::Concern

  def self.last_ticker
    Ticker.joins('INNER JOIN (select MAX(last_updated) as last_updated, symbol from tickers group by symbol) grouped_tk on tickers.symbol = grouped_tk.symbol and tickers.last_updated = grouped_tk.last_updated')
  end

  def self.last_price_usd(symbol)
    currency = Currency.find_by_symbol(symbol)
    if currency != nil
      return currency.price_usd
    end
    -1
  end

  def self.symbols
    Currency.all
        .order(:name).map {|sym| ["#{sym.name} (#{sym.symbol})", sym.symbol]}
  end


end