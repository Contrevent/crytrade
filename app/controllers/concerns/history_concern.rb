module HistoryConcern
  extend ActiveSupport::Concern
  include ViewModelConcern

  def history_def(width = 9, height = 25)
    create_vm :history, 'history/table', width, height,
              Trade.where(:user => current_user, :closed => true)
  end

  def history_columns
    [{name: 'start_date', allow_order: true, label: 'Start Date',
      get_label: lambda {|trade| trade.created_at.strftime('%b-%d %H:%M')},
      get_value: lambda {|trade| trade.created_at.to_time.to_i}},
     {name: 'close_date', allow_order: true, label: 'Close Date',
      get_label: lambda {|trade| trade.closed_at.strftime('%b-%d %H:%M')},
      get_value: lambda {|trade| trade.closed_at.to_time.to_i}},
     {name: 'pair', get_value: lambda {|trade| "#{trade.sell_symbol}/#{trade.buy_symbol}"}},
     {name: 'sell', get_value: lambda {|trade| "#{num_norm(trade.sell_count.abs)} #{trade.sell_symbol}"}},
     {name: 'buy', get_value: lambda {|trade| "#{num_norm(trade.count)} #{trade.buy_symbol}"}},
     {name: 'start', label: "Start (#{ref_char})",
      get_value: lambda {|trade| usd_to_ref_fine(trade.start_usd * trade.count)}},
     {name: 'current', label: "Stop (#{ref_char})",
      get_value: lambda {|trade| usd_to_ref_fine(trade.stop_usd * trade.count)}},
     {name: 'fees', label: "Fees (#{ref_char})",
      allow_order: true,
      get_value: lambda {|trade| usd_to_ref_fine(trade.fees_usd)}},
     {name: 'delta', label: "&Delta; (#{ref_char})", deco: true, green: 100, red: -100,
      allow_order: true,
      get_value: lambda {|trade| usd_to_ref_fine((trade.stop_usd - trade.start_usd) * trade.count - trade.fees_usd)}},
     {name: 'action', link: true, label: 'Edit',
      get_value: lambda {|trade| history_show_path(id: trade.id)}}
    ]
  end

end