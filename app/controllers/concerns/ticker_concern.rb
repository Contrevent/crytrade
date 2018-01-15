module TickerConcern
  extend ActiveSupport::Concern

  def self.last_ticker
    Ticker.joins('INNER JOIN (select MAX(last_updated) as last_updated, symbol from tickers group by symbol) grouped_tk on tickers.symbol = grouped_tk.symbol and tickers.last_updated = grouped_tk.last_updated')
  end

  def self.last_ticker_for(symbol)
    self.last_ticker.where(symbol: symbol).first
  end

  def self.last_price_usd(symbol)
    ticker = self.last_ticker_for(symbol)
    if ticker != nil
      return ticker.price_usd
    end
    -1
  end

  def self.symbols
    Ticker.select(:symbol, :currency_name).distinct(:symbol)
        .order(:currency_name).map {|sym| ["#{sym.currency_name} (#{sym.symbol})", sym.symbol]}
  end


end