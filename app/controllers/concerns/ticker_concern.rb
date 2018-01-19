module TickerConcern
  extend ActiveSupport::Concern

  def self.last_ticker
    Rails.cache.fetch('#cry_trade/tickers', expires_in: 4.minute) do
      Ticker.joins('INNER JOIN (select MAX(last_updated) as last_updated, symbol from tickers group by symbol) grouped_tk on tickers.symbol = grouped_tk.symbol and tickers.last_updated = grouped_tk.last_updated')
    end
  end

  def self.last_ticker_update
    Rails.cache.fetch('#cry_trade/tickers_update', expires_in: 4.minute) do
      Ticker.maximum(:updated_at)
    end
  end

  def self.last_price_usd(symbol)
    currency = TickerConcern::currencies[symbol]
    if currency != nil
      return currency[:price_usd]
    end
    -1
  end

  def self.symbols
    TickerConcern::currencies.sort_by {|k, v| v[:name]}
        .map {|elt| ["#{elt[1][:name]} (#{elt[0]})", elt[0]]}
  end

  private

  def self.currencies
    Rails.cache.fetch('#cry_trade/currencies', expires_in: 1.minute) do
      currencies = Hash.new

      Ticker.joins('INNER JOIN (select MAX(last_updated) as last_updated, symbol from tickers group by symbol) grouped_tk on tickers.symbol = grouped_tk.symbol and tickers.last_updated = grouped_tk.last_updated').each do |ticker|
        currencies[ticker.symbol] = {:name => ticker.currency_name, :price_usd => ticker.price_usd}
      end

      Fiat.all.each do |fiat|
        currencies[fiat.symbol] = {:name => fiat.name, :price_usd => fiat.price_usd}
      end
      currencies
    end
  end

end