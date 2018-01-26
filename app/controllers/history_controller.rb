class HistoryController < ApplicationController
  include ViewModelConcern
  include TickerConcern
  include HistoryConcern
  include LedgerConcern
  before_action :authenticate_user!

  def index
    populate history_def, funds_def
    @symbols = TickerConcern.symbols
    @trade = Trade.new
  end

  def update
    populate history_def
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
