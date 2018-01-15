class Trade < ApplicationRecord
  belongs_to :user
  include TickerConcern

  validates :symbol, presence: true
  validates :count, numericality: true, presence: true
  validates :start_usd, numericality: true, presence: true
  validates :init_stop_usd, numericality: true, presence: true

  def current_usd
    result = TickerConcern::last_price_usd(symbol)
    if result == -1
      Rails.logger.warn("Can't resolve ticker price for #{symbol}")
    end
    result
  end

end
