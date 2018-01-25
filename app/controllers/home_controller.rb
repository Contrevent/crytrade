class HomeController < ApplicationController
  include TickerConcern

  def index
    order_name, order_direction = TickerConcern::parse_order params
    @currencies = TickerConcern::last_ticker.where('volume_usd_24h > 10000000').order("tickers.#{order_name} #{order_direction}").limit(100)
    @columns = tick_columns(order_name, order_direction, lambda {|name, direction| root_path(col: name, dir: direction)})
    @refresh = true
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
