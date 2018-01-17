class Trade < ApplicationRecord
  belongs_to :user
  include TickerConcern

  validates :sell_symbol, presence: true
  validates :sell_start_usd, numericality: true, presence: true

  validates :buy_symbol, presence: true
  validates :count, numericality: true, presence: true
  validates :start_usd, numericality: true, presence: true
  validates :init_stop_usd, numericality: true, presence: true

  def current_usd
    result = TickerConcern::last_price_usd(buy_symbol)
    if result == -1
      Rails.logger.warn("Can't resolve ticker price for #{symbol}")
    end
    result
  end

end
