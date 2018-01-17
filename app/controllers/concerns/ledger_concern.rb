module LedgerConcern
  extend ActiveSupport::Concern
  include TickerConcern

  def balance
    Ledger.select('symbol, sum(count) as count').group(:symbol).where(:user => current_user)
  end

  def start_trade(trade)
    label = "Start trade #{trade.count} #{trade.buy_symbol}"
    Ledger.create(user: current_user, symbol: trade.sell_symbol, description:label, trade: trade, count: trade.sell_count, created_at: trade.created_at)
    Ledger.create(user: current_user, symbol: trade.buy_symbol, description:label, trade: trade, count: trade.count, created_at: trade.created_at)
  end

  def close_trade(trade)
    sell_rate = trade.sell_stop_usd
    buy_rate = trade.stop_usd
    buy_amount_usd = (trade.count * buy_rate) - trade.fees_usd
    sell_count = buy_amount_usd / sell_rate
    label = "Close trade #{trade.count} #{trade.buy_symbol}"
    Ledger.create(user: current_user, description:label, symbol: trade.buy_symbol, trade: trade, count: -trade.count)
    Ledger.create(user: current_user, description:label, symbol: trade.sell_symbol, trade: trade, count: sell_count)
  end

  def edit_trade(trade)
    destroy_trade(trade)
    start_trade(trade)
  end

  def destroy_trade(trade)
    Ledger.where(user: current_user, trade: trade).delete_all
  end

end