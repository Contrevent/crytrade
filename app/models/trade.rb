class Trade < ApplicationRecord
  belongs_to :user
  include TickerConcern

  validates :sell_symbol, presence: true
  validates :sell_start_usd, numericality:  {greater_than: 0}, presence: true

  validates :buy_symbol, presence: true
  validates :count, numericality: {greater_than: 0}, presence: true
  validates :start_usd, numericality:  {greater_than: 0}, presence: true
  validates :init_stop_usd, numericality:  {greater_than: 0}, presence: true

  validates :trailing_stop_usd, numericality:  {greater_than: 0}, presence: true
  validates :stop_usd, numericality:  {greater_than: 0}
  validates :gain_loss_usd, numericality: true


  def current_usd
    result = TickerConcern::last_price_usd(buy_symbol)
    if result == -1
      Rails.logger.warn("Can't resolve ticker price for #{symbol}")
    end
    result
  end

  def sell_count
     -count * start_usd / sell_start_usd
  end

end
