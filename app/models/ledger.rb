class Ledger < ApplicationRecord
  belongs_to :trade, optional: true
  belongs_to :user

  validates :count, numericality: true, presence: true

  def current_usd
    result = TickerConcern::last_price_usd(symbol)
    if result == -1
      Rails.logger.warn("Can't resolve ticker price for #{symbol}")
    end
    result
  end

end
