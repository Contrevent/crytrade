module TickerConcern
  extend ActiveSupport::Concern

  def self.last_ticker
    Rails.cache.fetch('#cry_trade/tickers', expires_in: 4.minute) do
      Ticker.joins('INNER JOIN (select MAX(last_updated) as last_updated, symbol from tickers group by symbol) grouped_tk on tickers.symbol = grouped_tk.symbol and tickers.last_updated = grouped_tk.last_updated')
    end
  end

  def self.columns(order_name = 'volume_usd_24h', order_direction = 'desc', order_path)
    col_defs = [
        {name: 'symbol', allow_order: true},
        {name: 'percent_change_1h', allow_order: true, label: '1h &Delta; (%)', deco: true,
         get_value: lambda {|currency| currency.percent_change_1h}
        },
        {name: 'percent_change_24h', allow_order: true, label: '24h &Delta; (%)', deco: true,
         get_value: lambda {|currency| currency.percent_change_24h}
        },
        {name: 'percent_change_7d', allow_order: true, label: '7d &Delta; (%)', deco: true,
         get_value: lambda {|currency| currency.percent_change_7d}
        },
        {name: 'currency_name', allow_order: true, label: 'Name'},
        {name: 'price_usd', allow_order: true, label: 'Price ($)',
         get_value: lambda {|currency| TickerConcern::present(currency.price_usd, 3)}},
        {name: 'price_btc', allow_order: true, label: 'Price (BTC)'},
        {name: 'volume_usd_24h', allow_order: true, label: '24h Vol. (M$)',
         get_value: lambda {|currency| TickerConcern::present((currency.volume_usd_24h / 1000000).round)}},
        {name: 'market_cap_usd', allow_order: true, label: 'Market Cap (M$)',
         get_value: lambda {|currency| currency.market_cap_usd != nil ?
                                           TickerConcern::present((currency.market_cap_usd / 1000000).round) : 'n.a.'}},
        {name: 'rank', allow_order: true},
        {name: 'cmc_link', allow_order: false, label: 'Cmc',
         link: lambda {|currency| "https://coinmarketcap.com/currencies/#{currency.currency_id}/"}}

    ].map {|col_def| TickerConcern::decorate_order(col_def, order_name, order_direction, order_path)}
  end

  def self.last_ticker_update
    Rails.cache.fetch('#cry_trade/tickers_update', expires_in: 30.seconds) do
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

  def self.decorate_order(col_def, order_name, order_direction, order_path)
    if col_def[:name] == order_name
      return col_def.merge({direction: order_direction, path:order_path.call(col_def[:name], order_direction == 'desc' ? 'asc' : 'desc')})
    end
    col_def.merge({path: order_path.call(col_def[:name], 'desc')})
  end

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


  def self.helper
    @@helper ||= Class.new do
      include ActionView::Helpers::NumberHelper
    end.new
  end

  def self.present(value, precision = 0)
    TickerConcern.helper.number_with_delimiter(value, precision: precision, delimiter: ' ')
  end


end