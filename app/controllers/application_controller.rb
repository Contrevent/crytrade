class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def index
    latest = Ticker.select('MAX(last_updated) as last_updated, symbol').group(:symbol).all
    ids = latest.map {|currency| Ticker.find_by(:last_updated => currency.last_updated, :symbol => currency.symbol).id}
    @currencies = Ticker.where(id: ids).order('volume_usd_24h DESC').limit(20)
    p @currencies

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
        {name: 'price_usd', align: 'center', label: 'Price ($)'},
        {name: 'price_btc', align: 'center', label: 'Price (BTC)'},
        {name: 'volume_usd_24h', align: 'center', label: '24h Volume (M$)',
         get_value: lambda {|currency| (currency.volume_usd_24h / 1000000).round}},
        {name: 'market_cap_usd', align: 'center', label: 'Market Cap (M$)',
         get_value: lambda {|currency| (currency.market_cap_usd / 1000000).round}},
        {name: 'percent_change_1h', label: '1h &Delta; (%)',align: 'center',
         get_value: lambda {|currency| arrow(currency.percent_change_1h)},
         kind: lambda {|currency| kind.call(currency.percent_change_1h)}
        },
        {name: 'percent_change_24h', label: '24h &Delta; (%)', align: 'center',
         get_value: lambda {|currency| arrow(currency.percent_change_24h)},
         kind: lambda {|currency| kind.call(currency.percent_change_24h)}},
        {name: 'percent_change_7d', label: '7d &Delta; (%)',align: 'center',
         get_value: lambda {|currency| arrow(currency.percent_change_7d)},
             kind: lambda {|currency| kind.call(currency.percent_change_7d)}},
        {name: 'cmc_link', label:'Cmc', align: 'center',
         link: lambda {|currency| "https://coinmarketcap.com/currencies/#{currency.currency_id}/"}}

    ]
  end



  private

  def arrow(value)
    code = value == 0 ? "=" : (value > 0 ? "&#9650;" : "&#9660;")
    "#{value} #{code}".html_safe
  end
end
