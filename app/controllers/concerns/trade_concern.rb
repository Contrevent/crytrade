module TradeConcern
  extend ActiveSupport::Concern
  include ViewModelConcern
  include RefConcern

  def trade_def(width = 0, height = 0)
    create_vm :trade, 'trade/table', width, height, nil
  end

  def trade_dash_def(width = 0, height = 0)
    create_vm :trade, 'trade/dash', width, height, nil
  end

  def new_trade_def(trade = nil)
    create_vm :new_trade, 'trade/create', 0, 0, (trade != nil ? trade : Trade.new)
  end

  def trade_facet
    facet(:trades, 'Trades', nil, trade_def, true, 'primary')
  end

  def new_trade_facet(trade = nil)
    facet(:new_trade, 'New Trade', nil, new_trade_def(trade), false, 'success')
  end

  def trade_columns
    [
        {name: 'created_at', allow_order: true, label: 'Created at',

         get_label: lambda {|trade| trade.created_at.strftime('%b-%d %H:%M')},
         get_value: lambda {|trade| trade.created_at.to_time.to_i}},
        {name: 'pair', get_value: lambda {|trade| "#{trade.sell_symbol}/#{trade.buy_symbol}"}},
        {name: 'buy', get_value: lambda {|trade| "#{num_norm(trade.count)} #{trade.buy_symbol}"}},
        {name: 'start', label: "Start (#{ref_char})",
         get_value: lambda {|trade| usd_to_ref_fine(trade.start_usd)}},
        {name: 'current', label: "Current (#{ref_char})",
         get_value: lambda {|trade| trade.current_usd == -1 ? 'n.a.' : usd_to_ref_fine(trade.current_usd)}},
        {name: 'delta', label: "&Delta; (#{ref_char})", deco: true, green: 100, red: -100,
         allow_order: true,
         get_value: lambda {|trade| delta trade}},
        {name: 'trailing', label: "Trailing (#{ref_char})",
         get_value: lambda {|trade| usd_to_ref_fine(trade.trailing_stop_usd)}},
        {name: 'init', label: "Init (#{ref_char})",
         get_value: lambda {|trade| usd_to_ref_fine(trade.init_stop_usd)}},
        {name: 'risk', label: "Risk (#{ref_char})", deco: true, green: 100, red: -100,
         get_value: lambda {|trade| usd_to_ref_fine((trade.trailing_stop_usd - trade.start_usd) * trade.count)}},
        {name: 'action', link: true, label: 'Edit',
         get_value: lambda {|trade| trades_show_path(id: trade.id)}}
    ]
  end

  def destroy_trade_facet(trade)
    facet(:destroy_trade, 'Delete', nil, destroy_trade_def(trade), false, 'danger')
  end

  def destroy_trade_def(trade)
    create_vm :destroy_trade, 'shared/delete', 0, 0, nil,
              {url: trades_destroy_path(id: trade.id)}
  end

  private

  def delta(trade)
    if trade.current_usd != -1
      current_total = (trade.current_usd - trade.start_usd) * trade.count
      usd_to_ref_norm(current_total)
    else
      "n.a."
    end
  end

end