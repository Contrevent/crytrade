class DashboardController < ApplicationController
  before_action :authenticate_user!
  include ViewModelConcern
  include TradeConcern
  include LedgerConcern
  include HistoryConcern
  include ScreenerConcern

  def index
    vms = []
    order_name, order_direction = TickerConcern::parse_order params
    Tile.where(user: current_user).order(:position).each do |tile|
      p "Adding #{tile.kind}"
      case (tile.kind.to_sym)
        when :screener_last
          vms.push(screener_last_def(tile.ref_id, order_name, order_direction, tile.width, tile.height))
        when :coins
          vms.push(coins_def(order_name, order_direction, tile.width, tile.height))
        when :funds
          vms.push(funds_def(tile.width, tile.height))
        when :funds_tickers
          vms.push(funds_tickers_def(order_name, order_direction, tile.width, tile.height))
        when :trade
          vms.push(trade_dash_def(tile.width, tile.height))
        when :trade_ticker
          vms.push(trades_tickers_def(order_name, order_direction, tile.width, tile.height))
        when :converter
          vms.push(converter_def(tile.width, tile.height))
      end
    end
    populate_by_array(vms)
  end
end
