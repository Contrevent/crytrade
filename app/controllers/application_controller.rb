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
    @columns = TickerConcern::columns(order_name, order_direction, lambda {|name, direction| root_path(col: name, dir:direction)})
    @last_update = TickerConcern::last_ticker_update
  end

  def about

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

end
