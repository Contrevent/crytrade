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
          # Primary support OK
          vms.push(screener_last_def(tile.ref_id, order_name, order_direction, tile.width, tile.height))
        when :coins
          # Primary support OK
          vms.push(coins_def(order_name, order_direction, tile.width, tile.height))
        when :funds
          # Primary support OK
          vms.push(funds_def(tile.width, tile.height))
        when :funds_tickers
          # Primary support OK
          vms.push(funds_tickers_def(order_name, order_direction, tile.width, tile.height))
        when :trade
          # Primary support OK
          vms.push(trade_dash_def(tile.width, tile.height))
        when :trade_ticker
          # Primary support OK
          vms.push(trades_tickers_def(order_name, order_direction, tile.width, tile.height))
        when :converter
          # Primary support TODO
          vms.push(converter_def(tile.width, tile.height))
      end
    end
    populate_by_array(vms)
  end
end
