class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include TickerConcern

  def index
    if params.key? (:col) and params.key? (:dir)
      order_name = params[:col]
      order_direction = params[:dir] == 'asc' ? 'asc' : 'desc'
    else
      order_name = 'volume_usd_24h'
      order_direction = 'desc'
    end

    @currencies = TickerConcern::last_ticker.where('volume_usd_24h > 10000000').order("tickers.#{order_name} #{order_direction}").limit(100)

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
         get_value: lambda {|currency| present(currency.price_usd, 3)}},
        {name: 'price_btc', allow_order: true, label: 'Price (BTC)'},
        {name: 'volume_usd_24h', allow_order: true, label: '24h Vol. (M$)',
         get_value: lambda {|currency| present((currency.volume_usd_24h / 1000000).round)}},
        {name: 'market_cap_usd', allow_order: true, label: 'Market Cap (M$)',
         get_value: lambda {|currency| currency.market_cap_usd != nil ? present((currency.market_cap_usd / 1000000).round) : 'n.a.'}},
        {name: 'rank', allow_order: true},
        {name: 'cmc_link', allow_order: false, label: 'Cmc',
         link: lambda {|currency| "https://coinmarketcap.com/currencies/#{currency.currency_id}/"}}

    ]


    @columns = col_defs.map {|col_def| decorate_order(col_def, order_name, order_direction)}
    @last_update = TickerConcern::last_ticker_update
  end

  def ticker
    if params.key?(:symbol)
      price = TickerConcern::last_price_usd(params[:symbol])
      render json: {'price': price}
    else
      render text: "Bad Request", status: 400
    end
  end

  def refresh
    CmcTickerJob.perform_now
    redirect_to action: 'index'
  end


  private

  def decorate_order(col_def, order_name, order_direction)
    if col_def[:name] == order_name
      return col_def.merge({direction: order_direction})
    end
    col_def
  end

  def helper
    @helper ||= Class.new do
      include ActionView::Helpers::NumberHelper
    end.new
  end

  def present(value, precision = 0)
    helper.number_with_delimiter(value, precision: precision, delimiter: ' ')
  end

end
