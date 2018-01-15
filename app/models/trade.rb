class Trade < ApplicationRecord
  belongs_to :user

  validates :symbol, presence: true
  validates :count, numericality: true, presence: true
  validates :start_usd, numericality: true, presence: true
  validates :init_stop_usd, numericality: true, presence: true

  def current_usd
    last_update = Ticker.select(:symbol).maximum(:last_updated)
    if last_update > 0
      ticker = Ticker.find_by(:symbol => symbol, :last_updated => last_update)
      if ticker != nil
        return ticker.price_usd
      else
        Rails.logger.warn("Can't resolve ticker price for #{symbol}")
      end
    end
    -1
  end

end
