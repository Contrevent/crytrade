module LedgerConcern
  extend ActiveSupport::Concern

  def balance
    Ledger.select('symbol, sum(count) as count').group(:symbol).where(:user => current_user)
  end

end