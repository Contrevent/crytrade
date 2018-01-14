class Ticker < ApplicationRecord

  def score
    value = -10000000
    unless volume_usd_24h < 50000000
      value = 100*percent_change_1h + 10*percent_change_24h + percent_change_7d
    end
    value
  end

end
