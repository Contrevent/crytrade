class TradeController < ApplicationController
  include TickerConcern
  include LedgerConcern
  include TradeConcern
  include ViewModelConcern
  include FacetsConcern
  include RefConcern
  before_action :authenticate_user!

  def index
    if request.format == :json
      trades_api
    else
      index_facets :funds
    end
  end

  def create
    trade = Trade.new create_params
    if ref_coin != 'USD'
      # :sell_start_usd, :start_usd, :init_stop_usd
      trade.start_usd = ref_to_usd trade.start_usd
      trade.sell_start_usd = ref_to_usd trade.sell_start_usd
      trade.init_stop_usd = ref_to_usd trade.init_stop_usd
    end
    trade.trailing_stop_usd = trade.init_stop_usd
    trade.stop_usd = trade.init_stop_usd
    trade.user = current_user
    if trade.save
      start_trade trade
      flash[:notice] = "Trade created."
      redirect_to action: 'index'
    else
      if ref_coin != 'USD'
        # :sell_start_usd, :start_usd, :init_stop_usd
        trade.start_usd = usd_to_ref_fine trade.start_usd
        trade.sell_start_usd = usd_to_ref_fine trade.sell_start_usd
        trade.init_stop_usd = usd_to_ref_fine trade.init_stop_usd
      end
      index_facets :new_trade, trade
      render 'index'
    end
  end

  def show
    trade = Trade.find(params[:id])
    if ref_coin != 'USD'
      trade.start_usd = usd_to_ref_fine trade.start_usd
      trade.sell_start_usd = usd_to_ref_fine trade.sell_start_usd
      trade.init_stop_usd = usd_to_ref_fine trade.init_stop_usd
      trade.trailing_stop_usd = usd_to_ref_fine trade.trailing_stop_usd
    end
    trade.stop_usd = trade.trailing_stop_usd
    trade.sell_stop_usd = usd_to_ref_fine TickerConcern::last_price_usd(trade.sell_symbol)
    item_facets :close_trade, trade
  end

  def update
    trade = Trade.find(params[:id])
    if trade != nil
      trade.update(edit_params)
      if ref_coin != 'USD'
        # :sell_start_usd, :start_usd, :init_stop_usd, :count, :trailing_stop_usd
        trade.start_usd = ref_to_usd trade.start_usd
        trade.sell_start_usd = ref_to_usd trade.sell_start_usd
        trade.init_stop_usd = ref_to_usd trade.init_stop_usd
        trade.trailing_stop_usd = ref_to_usd trade.trailing_stop_usd
      end
      trade.stop_usd = trade.trailing_stop_usd
      if trade.save
        edit_trade(trade)
        flash[:notice] = "Trade updated."
        redirect_to action: 'index'
      else
        if ref_coin != 'USD'
          # :sell_start_usd, :start_usd, :init_stop_usd, :count, :trailing_stop_usd
          trade.start_usd = usd_to_ref_fine trade.start_usd
          trade.sell_start_usd = usd_to_ref_fine trade.sell_start_usd
          trade.init_stop_usd = usd_to_ref_fine trade.init_stop_usd
          trade.trailing_stop_usd = usd_to_ref_fine trade.trailing_stop_usd
        end
        item_facets :edit_trade, trade
        render 'show'
      end
    else
      flash[:error] = "Invalid values."
      redirect_to action: 'index'
    end
  end

  def close
    trade = Trade.find(params[:id])
    if trade != nil
      trade.update(close_params)
      if ref_coin != 'USD'
        # :stop_usd, :sell_stop_usd, :fees_usd
        trade.stop_usd = ref_to_usd trade.stop_usd
        trade.sell_stop_usd = ref_to_usd trade.sell_stop_usd
        trade.fees_usd = ref_to_usd trade.fees_usd
      end
      trade.closed = true
      trade.closed_at = DateTime.now
      trade.gain_loss_usd = (trade.stop_usd - trade.start_usd) * trade.count - trade.fees_usd
      if trade.save
        close_trade(trade)
        flash[:notice] = "Trade closed."
        redirect_to controller: 'history', action: 'update', id: trade.id
      else
        if ref_coin != 'USD'
          # :stop_usd, :sell_stop_usd, :fees_usd
          trade.stop_usd = usd_to_ref_fine trade.stop_usd
          trade.sell_stop_usd = usd_to_ref_fine trade.sell_stop_usd
          trade.fees_usd = usd_to_ref_fine trade.fees_usd
        end
        item_facets :close_trade, trade
        render 'show'
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

  def trades_api
    order_name = 'created_at'
    order_direction = 'desc'
    cols = trade_columns
    data = Trade.where(:user => current_user, :closed => false)
               .order("#{order_name} #{order_direction}")
               .map {|obj| obj.to_json(cols)}

    react_view 'Trades', {cols: cols.map {|col| col_to_json(col)},
                          data: data, order: {field: order_name, dir: order_direction}}, 30
  end

  def create_params
    params.require(:trade).permit(:buy_symbol, :sell_symbol, :sell_start_usd, :start_usd, :init_stop_usd, :count)
  end

  def edit_params
    params.require(:trade).permit(:id, :sell_start_usd, :start_usd, :init_stop_usd, :count, :trailing_stop_usd)
  end

  def close_params
    params.require(:trade).permit(:id, :stop_usd, :sell_stop_usd, :fees_usd)
  end

  def item_facets(active, trade)
    @facets = activate active, trade_facet, close_trade_facet(trade),
                       edit_trade_facet(trade), destroy_trade_facet(trade), back_facet
  end

  def index_facets(active, trade = nil)
    @facets = activate active, trade_facet, funds_facet, new_trade_facet(trade)
  end

  def close_trade_facet(trade)
    facet(:close_trade, 'Close', nil, close_trade_def(trade), false, 'info')
  end

  def edit_trade_facet(trade)
    facet(:edit_trade, 'Edit', nil, edit_trade_def(trade), false, 'primary')
  end

  def back_facet
    facet(:back, 'Back', trades_url)
  end

  def close_trade_def(trade = nil)
    item_vm :close_trade, 'trade/close', trade
  end

  def edit_trade_def(trade = nil)
    item_vm :edit_trade, 'trade/edit', trade
  end


  def item_vm(symbol, view, trade)
    create_vm symbol, view, 0, 0, trade
  end

end
