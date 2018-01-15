class TradeController < ApplicationController

  def list
    @trades = Trade.where(:user => current_user)
    @symbols = Ticker.select(:symbol).distinct.map {|sym| [sym.symbol, sym.symbol]}
    @trade = Trade.new
  end

  def create
    permitted = create_params
    if permitted.permitted?
      trade = Trade.new(create_params)
      trade.trailing_stop_usd = trade.init_stop_usd
      trade.user = current_user
      trade.save
      flash[:notice] = "Trade created."
      redirect_to action: 'list'
    else
      flash[:error] = "Invalid values."
    end
  end

  def update
    @trades = Trade.where(:user => current_user)
    @symbols = Ticker.select(:symbol).distinct.map {|sym| [sym.symbol, sym.symbol]}
    @trade = Trade.find(params[:id])
    @trade.stop_usd = @trade.trailing_stop_usd
  end

  def update_post
    permitted = edit_params
    if permitted.permitted?
      trade = Trade.find(params[:trade][:id])
      trade.update(permitted)
      flash[:notice] = "Trade updated."
      redirect_to action: 'list'
    else
      flash[:error] = "Invalid values."
    end
  end

  def close
    trade = Trade.find(params[:id])
    if trade != nil
      trade.closed = true
      trade.closed_at= DateTime.now
      trade.stop_usd = params[:stop_usd]
      trade.save
      flash[:notice] = "Trade closed."
    end
    redirect_to action: 'list'
  end

  def destroy
    trade = Trade.find(params[:id])
    if trade != nil
      trade.destroy
      flash[:notice] = "Trade deleted."
    end
    redirect_to action: 'list'
  end

  private
  def create_params
    params.require(:trade).permit(:symbol, :start_usd, :init_stop_usd, :count)
  end

  def edit_params
    params.require(:trade).permit(:id, :start_usd, :init_stop_usd, :count, :trailing_stop_usd)
  end

end