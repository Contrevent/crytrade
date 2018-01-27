class HomeController < ApplicationController
  include TickerConcern
  include ScreenerConcern
  include ViewModelConcern
  
  def index
    order_name, order_direction = TickerConcern::parse_order params
    populate coins_def(order_name, order_direction)
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
    if params.key? :c and params.key? :a
      redirect_to controller: params[:c], action: params[:a]
    else
      redirect_to action: 'index'
    end
  end


end
