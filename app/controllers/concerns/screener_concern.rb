module ScreenerConcern
  extend ActiveSupport::Concern
  include TickerConcern
  include ViewModelConcern

  def screener_last_def(screener_id, order_name, order_direction, width = 9, height = 25)
    create_vm :screener_last, 'screener/coins', width, height,
              populate_screener(screener_id, order_name, order_direction)
  end

  def screener_view_def(job_id, order_name, order_direction, width = 9, height = 25)
    create_vm :screener_view, 'screener/coins', width, height,
              populate_job(job_id, order_name, order_direction,
                           lambda {|name, direction| screener_view_path(id: job_id, col: name, dir: direction)})
  end

  def coins_def(order_name, order_direction, width = 12, height = 25)
    create_vm :coins, 'screener/coins', width, height,
              populate_coins(order_name, order_direction)
  end

  def trades_tickers_def(order_name, order_direction, width=12, height=25)
    trades = Trade.where(user: current_user, closed: false).map{|trade| trade.buy_symbol}
    create_vm :trade_ticker, 'screener/coins', width, height, {
        cols: tick_columns(order_name, order_direction, lambda {|name, direction| root_path(col: name, dir: direction)}),
        data: TickerConcern::last_ticker.where('tickers.symbol in (?)', trades).order("tickers.#{order_name} #{order_direction}").limit(100)
    }
  end

  private

  def populate_coins(order_name, order_direction)
    {
        cols: tick_columns(order_name, order_direction, lambda {|name, direction| root_path(col: name, dir: direction)}),
        data: TickerConcern::last_ticker.where('volume_usd_24h > 10000000').order("tickers.#{order_name} #{order_direction}").limit(100)
    }
  end

  def populate_screener(screener_id, order_name, order_direction)
    screener = Screener.find(screener_id)
    if screener.last_job_id > -1
      populate_job(screener.last_job_id, order_name, order_direction,
                   lambda {|name, direction| screener_last_path(id: screener.id, col: name, dir: direction)})
    else
      {}
    end
  end

  def populate_job(job_id, order_name, order_direction, order_path)
    job = ScreenerJob.find(job_id)
    if job != nil
      {cols: tick_columns(order_name, order_direction, order_path),
       data: sort_result(job, order_name, order_direction),
       job: job}
    else
      {}
    end
  end

  def sort_result(job, col, dir)
    result = ScreenerResult.where(screener_job: job).map {|result| result.ticker}
                 .sort_by {|ticker| ticker[col] != nil ? ticker[col] : -1}
    if dir == 'desc'
      result.reverse!
    else
      result
    end
  end


end