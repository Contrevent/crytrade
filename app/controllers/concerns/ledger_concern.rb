module LedgerConcern
  extend ActiveSupport::Concern
  include TickerConcern
  include ViewModelConcern
  include RefConcern

  def funds_def(width = 0, height = 0)
    create_vm :funds, 'ledger/funds_react', width, height, nil
  end

  def funds_facet
    facet(:funds, 'Funds', nil, funds_def)
  end

  def entries
    Ledger.where(:user => current_user).order('created_at desc')
  end

  def balance_ref(entry)
    usd_price = TickerConcern::last_price_usd(entry.symbol)
    if usd_price > 0
      usd_to_ref_norm(entry.current_usd * entry.count)
    else
      'n.a.'
    end

  end

  def balance_too_small_reject(entry)
    if entry[:count].abs < 0.01
      return true
    else
      ref_dol_cent = ref_value(0.01)
      if ref_dol_cent.is_a? Numeric and entry[:count_ref].is_a? Numeric and entry[:count_ref].abs < ref_dol_cent
        return true
      end
    end
    false
  end

  def balance
    Ledger.select('symbol, sum(count) as count').group(:symbol).where(:user => current_user)
        .map {|entry| {symbol: entry.symbol, count: entry.count, count_ref: balance_ref(entry)}}
        .reject {|entry| balance_too_small_reject(entry)}
        .sort_by {|entry| (entry[:count_ref].is_a? Numeric) ? -entry[:count_ref] : 1}
  end

  def start_trade(trade)
    label = "Start trade #{trade.count} #{trade.buy_symbol}"
    Ledger.create(user: current_user, symbol: trade.buy_symbol, description: label, trade: trade, count: trade.count, created_at: trade.created_at)
    Ledger.create(user: current_user, symbol: trade.sell_symbol, description: label, trade: trade, count: trade.sell_count, created_at: trade.created_at)
  end

  def close_trade(trade)
    sell_rate = trade.sell_stop_usd
    buy_rate = trade.stop_usd
    buy_amount_usd = (trade.count * buy_rate) - trade.fees_usd
    sell_count = buy_amount_usd / sell_rate
    label = "Close trade #{trade.count} #{trade.buy_symbol}"
    Ledger.create(user: current_user, description: label, symbol: trade.sell_symbol, trade: trade, count: sell_count)
    Ledger.create(user: current_user, description: label, symbol: trade.buy_symbol, trade: trade, count: -trade.count)
  end

  def edit_trade(trade)
    destroy_trade(trade)
    start_trade(trade)
  end

  def open_trade(trade)
    destroy_trade(trade)
    start_trade(trade)
  end

  def destroy_trade(trade)
    Ledger.where(user: current_user, trade: trade).delete_all
  end

  def funds_columns
    [{name: 'symbol', allow_order: true, label: 'Symbol',
      get_value: lambda {|balance| balance[:symbol]}},
     {name: 'count', allow_order: true, label: 'Balance',
      get_value: lambda {|balance| num_norm(balance[:count])}},
     {name: 'count_ref', allow_order: true, label: "Balance (#{ref_char})",
      get_value: lambda {|balance| balance[:count_ref]}}
    ]
  end

end