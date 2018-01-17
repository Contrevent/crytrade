class TradeController < ApplicationController
  include TickerConcern
  include LedgerConcern

  def index
    @trades = Trade.where(:user => current_user, :closed => false)
    @symbols = TickerConcern.symbols
    @trade = Trade.new
    @balance = balance
  end

  def create
    permitted = create_params
    if permitted.permitted?
      trade = Trade.new
      trade.sell_symbol = permitted[:sell_symbol]
      trade.sell_start_usd = permitted[:sell_start_usd]
      trade.buy_symbol = permitted[:buy_symbol]
      trade.start_usd = permitted[:start_usd]
      trade.count = permitted[:count]
      trade.init_stop_usd = permitted[:init_stop_usd]
      trade.trailing_stop_usd = trade.init_stop_usd
      trade.user = current_user
      trade.save
      start_trade trade
      flash[:notice] = "Trade created."
      redirect_to action: 'index'
    else
      flash[:error] = "Invalid values."
    end
  end

  def update
    @trades = Trade.where(:user => current_user, :closed => false)
    @trade = Trade.find(params[:id])
    @trade.stop_usd = @trade.trailing_stop_usd
    @trade.sell_stop_usd = TickerConcern::last_price_usd(@trade.sell_symbol)
  end

  def update_post
    permitted = edit_params
    if permitted.permitted?
      trade = Trade.find(params[:trade][:id])
      trade.update(permitted)
      edit_trade(trade)
      flash[:notice] = "Trade updated."
      redirect_to action: 'index'
    else
      flash[:error] = "Invalid values."
    end
  end

  def close
    trade = Trade.find(params[:trade][:id])
    if trade != nil
      trade.closed = true
      trade.closed_at = DateTime.now
      trade.stop_usd = params[:trade][:stop_usd]
      trade.fees_usd = params[:trade][:fees_usd]
      trade.sell_stop_usd = params[:trade][:sell_stop_usd]
      trade.gain_loss_usd = (trade.stop_usd - trade.start_usd) * trade.count - trade.fees_usd
      trade.save
      close_trade(trade)
      flash[:notice] = "Trade closed."
    end
    redirect_to action: 'index'
  end

  def destroy
    trade = Trade.find(params[:id])
    if trade != nil
      destroy_trade(trade)
      trade.destroy
      flash[:notice] = "Trade deleted."
    end
    redirect_to action: 'index'
  end

  private
  def create_params
    params.require(:trade).permit(:buy_symbol, :sell_symbol, :sell_start_usd, :start_usd, :init_stop_usd, :count)
  end

  def edit_params
    params.require(:trade).permit(:id, :sell_start_usd, :start_usd, :init_stop_usd, :count, :trailing_stop_usd)
  end

end
