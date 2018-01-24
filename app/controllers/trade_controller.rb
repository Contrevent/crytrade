class TradeController < ApplicationController
  include TickerConcern
  include LedgerConcern

  def index
    @trades = Trade.where(:user => current_user, :closed => false)
    @symbols = TickerConcern.symbols
    @trade = Trade.new
    @balance = balance
    @refresh = true
  end

  def create
    @trade = Trade.new create_params
    @trade.trailing_stop_usd = @trade.init_stop_usd
    @trade.stop_usd = @trade.init_stop_usd
    @trade.user = current_user
    if @trade.save
      start_trade @trade
      flash[:notice] = "Trade created."
      redirect_to action: 'index'
    else
      @trades = Trade.where(:user => current_user, :closed => false)
      @symbols = TickerConcern.symbols
      @balance = balance
      render 'index'
    end
  end

  def update
    @trades = Trade.where(:user => current_user, :closed => false)
    @trade = Trade.find(params[:id])
    @trade.stop_usd = @trade.trailing_stop_usd
    @trade.sell_stop_usd = TickerConcern::last_price_usd(@trade.sell_symbol)
  end

  def update_post
    @trade = Trade.find(params[:trade][:id])
    if @trade != nil
      @trade.update(edit_params)
      @trade.stop_usd = @trade.trailing_stop_usd
      if @trade.save
        edit_trade(@trade)
        flash[:notice] = "Trade updated."
        redirect_to action: 'index'
      else
        @trades = Trade.where(:user => current_user, :closed => false)
        render 'update'
      end
    else
      flash[:error] = "Invalid values."
      redirect_to action: 'index'
    end
  end

  def close
    @trade = Trade.find(params[:trade][:id])
    if @trade != nil
      @trade.update(close_params)
      @trade.closed = true
      @trade.closed_at = DateTime.now
      @trade.gain_loss_usd = (@trade.stop_usd - @trade.start_usd) * @trade.count - @trade.fees_usd
      if @trade.save
        close_trade(@trade)
        flash[:notice] = "Trade closed."
        redirect_to controller: 'history', action: 'update', id: @trade.id
      else
        @trades = Trade.where(:user => current_user, :closed => false)
        render 'update'
      end
    else
      flash[:error] = "Invalid values."
      redirect_to action: 'index'
    end
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

  def close_params
    params.require(:trade).permit(:id, :stop_usd, :sell_stop_usd, :fees_usd)
  end

end
