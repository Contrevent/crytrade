class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include TickerConcern

  def index
    @currencies = TickerConcern::last_ticker.order('volume_usd_24h DESC').limit(30)

    kind = lambda {|value| (
    if value == 0
      "info"
    elsif value < 0
      "danger"
    else
      "success"
    end)}
    @columns = [
        {name: 'symbol', align: 'left'},
        {name: 'currency_name', align: 'left', label: 'Name'},
        {name: 'rank', align: 'center'},
        {name: 'price_usd', align: 'center', label: 'Price ($)',
         get_value: lambda {|currency| present(currency.price_usd, 3)}},
        {name: 'price_btc', align: 'center', label: 'Price (BTC)'},
        {name: 'volume_usd_24h', align: 'center', label: '24h Volume (M$)',
         get_value: lambda {|currency| present((currency.volume_usd_24h / 1000000).round)}},
        {name: 'market_cap_usd', align: 'center', label: 'Market Cap (M$)',
         get_value: lambda {|currency| present((currency.market_cap_usd / 1000000).round)}},
        {name: 'percent_change_1h', label: '1h &Delta; (%)', align: 'center',
         get_value: lambda {|currency| arrow(currency.percent_change_1h)},
         kind: lambda {|currency| kind.call(currency.percent_change_1h)}
        },
        {name: 'percent_change_24h', label: '24h &Delta; (%)', align: 'center',
         get_value: lambda {|currency| arrow(currency.percent_change_24h)},
         kind: lambda {|currency| kind.call(currency.percent_change_24h)}},
        {name: 'percent_change_7d', label: '7d &Delta; (%)', align: 'center',
         get_value: lambda {|currency| arrow(currency.percent_change_7d)},
         kind: lambda {|currency| kind.call(currency.percent_change_7d)}},
        {name: 'cmc_link', label: 'Cmc', align: 'center',
         link: lambda {|currency| "https://coinmarketcap.com/currencies/#{currency.currency_id}/"}}

    ]
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

  def helper
    @helper ||= Class.new do
      include ActionView::Helpers::NumberHelper
    end.new
  end

  def present(value, precision = 0)
    helper.number_with_delimiter(value, precision: precision, delimiter: ' ')
  end

  def arrow(value)
    code = if value == 0 then
             "="
           else
             value > 0 ? "&#9650;" : "&#9660;"
           end
    "#{value} #{code}".html_safe
  end
end
