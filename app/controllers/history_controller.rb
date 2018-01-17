class HistoryController < ApplicationController
  include TickerConcern
  include LedgerConcern

  def index
    @trades = Trade.where(:user => current_user, :closed => true)
    @symbols = TickerConcern.symbols
    @trade = Trade.new
    @balance = balance
  end

  def update
    @trades = Trade.where(:user => current_user, :closed => true)
    @trade = Trade.find(params[:id])
  end

  def open
    trade = Trade.find(params[:trade][:id])
    trade.closed = false
    trade.save
    open_trade(trade)
    redirect_to controller: 'trade', action: 'update', id: trade.id
  end
end
