class HistoryController < ApplicationController
  include ViewModelConcern
  include TickerConcern
  include HistoryConcern
  include TradeConcern
  include LedgerConcern
  before_action :authenticate_user!

  def index
    if request.format == :json
      history_table
    else
      index_facets :funds
    end
  end

  def show
    trade = Trade.find(params[:id])
    if trade != nil
      show_facets :open_trade, trade
    else
      render status: 404
    end
  end

  def open
    trade = Trade.find(params[:trade][:id])
    trade.closed = false
    trade.save
    open_trade(trade)
    redirect_to controller: 'trade', action: 'show', id: trade.id
  end

  private

  def index_facets(active, entry = nil)
    @facets = activate active, history_facet, funds_facet
  end

  def history_facet
    facet(:ledger, 'History', nil, history_def, true, 'primary')
  end

  def history_def
    create_vm :ledger, 'history/table', 0, 0, nil
  end

  def history_table
    cols = history_columns
    data = Trade.where(:user => current_user, :closed => true)
               .map {|obj| obj.to_json(cols)}

    react_view 'History', {cols: cols.map {|col| col_to_json(col)},
                           data: data, order: {field: 'close_date', dir: 'desc'}}, 0
  end

  def show_facets(active, entry = nil)
    @facets = activate active, history_facet, open_facet(entry), destroy_trade_facet(entry), back_facet
  end

  def open_facet(entry)
    facet(:open_trade, 'Open', nil, open_trade_def(entry), false, 'info')
  end

  def open_trade_def(trade = nil)
    create_vm :open_trade, 'history/open', 0, 0, trade
  end

  def back_facet
    facet(:back, 'Back', history_url)
  end
end
