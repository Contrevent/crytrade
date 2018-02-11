module TickerConcern
  extend ActiveSupport::Concern
  include RefConcern

  def self.last_ticker
    Rails.cache.fetch('#cry_trade/tickers', expires_in: 1.minute) do
      Ticker.joins('INNER JOIN (select MAX(last_updated) as last_updated, symbol from tickers group by symbol) grouped_tk on tickers.symbol = grouped_tk.symbol and tickers.last_updated = grouped_tk.last_updated')
    end
  end

  def self.parse_order(params)
    if params.key? (:col) and params.key? (:dir)
      order_name = params[:col]
      order_direction = params[:dir] == 'asc' ? 'asc' : 'desc'
    else
      order_name = 'volume_usd_24h'
      order_direction = 'desc'
    end
    [order_name, order_direction]
  end

  def col_to_json(col)
    result = Hash.new
    allowed_props = [:name, :label, :link, :target, :deco, :allow_order, :red, :green]
    allowed_props.each do |key|
      if col.key? key
        result[key] = col[key]
      end
    end
    result
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

  def coin_symbols
    TickerConcern::currencies.sort_by {|k, v| v[:name]}
        .map {|elt| ["#{elt[1][:name]} (#{elt[0]})", elt[0]]}
  end

  private

  def self.decorate_order(col_def, order_name, order_direction, order_path)
    if col_def[:name] == order_name
      return col_def.merge({direction: order_direction, path: order_path.call(col_def[:name], order_direction == 'desc' ? 'asc' : 'desc')})
    end
    col_def.merge({path: order_path.call(col_def[:name], 'desc')})
  end

  def self.currencies
    Rails.cache.fetch('#cry_trade/currencies', expires_in: 1.minute) do
      currencies = Hash.new

      Ticker.joins('INNER JOIN (select MAX(last_updated) as last_updated, symbol from tickers group by symbol) grouped_tk on tickers.symbol = grouped_tk.symbol and tickers.last_updated = grouped_tk.last_updated').each do |ticker|
        currencies[ticker.symbol] = {:name => ticker.currency_name, :price_usd => ticker.price_usd, :fiat => false}
      end

      Fiat.all.each do |fiat|
        currencies[fiat.symbol] = {:name => fiat.name, :price_usd => fiat.price_usd, :fiat => true}
      end
      currencies
    end
  end

  def self.is_not_fiat(symbol)
    !TickerConcern::currencies[symbol][:fiat]
  end

end