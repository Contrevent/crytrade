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

  def settings
    @symbols = TickerConcern.symbols
    @user = current_user
  end

  def post_settings
    @user = current_user
    @user.update settings_params
    if @user.save
      flash[:notice] = "Settings save."
      redirect_to action: 'settings'
    else
      @symbols = TickerConcern.symbols
      render 'settings'
    end
  end

  private

  def settings_params
    params.require(:user).permit(:reference_precision, :reference_character, :reference_symbol)
  end

end
