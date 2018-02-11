module ScreenerConcern
  extend ActiveSupport::Concern
  include TickerConcern
  include ViewModelConcern

  def screener_last_def(screener_id, order_name, order_direction, width = 9, height = 25)
    screener = Screener.find(screener_id)
    job = nil
    count = 0
    if screener.last_job_id > -1
      job = ScreenerJob.find(screener.last_job_id)
      if job&.done?
        count = ScreenerResult.where(screener_job: job).count
      end
    end
    create_vm :screener_last, 'screener/coins_react', width, height, {job: job, count: count}, {url: screeners_last_path(id: screener_id)}
  end

  def screener_view_def(job_id, order_name, order_direction, width = 9, height = 25)
    job = ScreenerJob.find(job_id)
    count = 0
    if job&.done?
      count = ScreenerResult.where(screener_job: job).count
    end
    create_vm :screener_view, 'screener/coins_react', width, height, {job: job, count: count}, {url: screeners_show_path(id: job_id)}
  end

  def coins_def(order_name, order_direction, width = 12, height = 25)
    create_vm :coins, 'screener/coins_react', width, height, nil, {url: api_coins_url}
  end

  def trades_tickers_def(order_name, order_direction, width = 12, height = 25)
    create_vm :trade_ticker, 'screener/coins_react', width, height, nil, {url: screeners_trades_url}
  end

  def funds_tickers_def(order_name, order_direction, width = 12, height = 25)
    create_vm :funds_tickers, 'screener/coins_react', width, height, nil, {url: screeners_funds_url}
  end

  def coins_columns
    cols = [
        {name: 'symbol', allow_order: true},
        {name: 'percent_change_1h', allow_order: true, label: '1h &Delta; (%)', deco: true,
         get_value: lambda {|currency| to_float(currency.percent_change_1h)}
        },
        {name: 'percent_change_24h', allow_order: true, label: '24h &Delta; (%)', deco: true,
         get_value: lambda {|currency| to_float(currency.percent_change_24h)}
        },
        {name: 'percent_change_7d', allow_order: true, label: '7d &Delta; (%)', deco: true,
         get_value: lambda {|currency| to_float(currency.percent_change_7d)}
        },
        {name: 'currency_name', allow_order: true, label: 'Name'},
        {name: 'price_usd', allow_order: true, label: 'Price ($)',
         get_value: lambda {|currency| num_fine(currency.price_usd)}},
        {name: 'volume_usd_24h', allow_order: true, label: '24h Vol. (M$)',
         get_value: lambda {|currency| num_norm((currency.volume_usd_24h / 1000000).round)}},
        {name: 'market_cap_usd', allow_order: true, label: 'Market Cap (M$)',
         get_value: lambda {|currency| currency.market_cap_usd != nil ?
                                           num_norm((currency.market_cap_usd / 1000000).round) : 'n.a.'}},
        {name: 'rank', allow_order: true},
        {name: 'cmc_link', allow_order: false, label: 'Cmc', link: true,
         get_value: lambda {|currency| "https://coinmarketcap.com/currencies/#{currency.currency_id}/"}}

    ]
    if ref_coin == 'USD'
      cols = cols.insert(6, {name: 'price_btc', allow_order: true, label: 'Price (BTC)',
                             get_value: lambda {|currency| num_fine(currency.price_btc)}})
    else
      cols = cols.insert(6, {name: 'price_' + ref_coin, allow_order: true, label: "Price (#{ref_char})",
                             get_value: lambda {|currency| usd_to_ref_fine(currency.price_usd)}})
    end
    cols
  end

  def coins_data
    TickerConcern::last_ticker
        .where('volume_usd_24h > 10000000')
        .limit(100)
  end

  def coins_order
    order_name, order_direction = TickerConcern::parse_order params
    {field: order_name, dir: order_direction}
  end

  def react_coins(data = coins_data)
    cols = coins_columns
    react_view 'Coins', {cols: cols.map {|col| col_to_json(col)},
                         data: data.map {|obj| obj.to_json(cols)}, order: coins_order}, 30
  end

  def react_coins_last(screener_id)
    screener = Screener.find(screener_id)
    if screener.last_job_id > -1
      react_coins_view(screener.last_job_id)
    else
      render status: 404
    end
  end

  def react_coins_view(job_id)
    job = ScreenerJob.find(job_id)
    if job != nil
      tickers = ScreenerResult.where(screener_job: job).map {|result| result.ticker}
      react_coins tickers
    else
      render status: 404
    end
  end

  def react_coins_trades
    trades = Trade.where(user: current_user, closed: false).map {|trade| trade.buy_symbol}
    trades_tickers = TickerConcern::last_ticker.where('tickers.symbol in (?)', trades)
    react_coins trades_tickers
  end

  def react_coins_funds
    funds = Ledger.select('symbol, sum(count) as count').group(:symbol).where(user: current_user)
                .select {|entry| entry.count.abs > 0.01 && TickerConcern::is_not_fiat(entry.symbol)}.map {|coin| coin.symbol}
    funds_tickers = TickerConcern::last_ticker.where('tickers.symbol in (?)', funds)
    react_coins funds_tickers
  end


end