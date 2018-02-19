class TickerArchiveJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    start_date = Ticker.minimum(:created_at).at_beginning_of_day
    end_date = DateTime.now.at_beginning_of_day - 10.days
    Rails.logger.info "Start archiving..."
    if start_date < end_date
      day_count = (end_date.to_i - start_date.to_i) / 1.day
      Rails.logger.info "Archiving period [#{date_to_s start_date}, #{date_to_s end_date}] : #{day_count} days"
      current_date = start_date
      while current_date < end_date
        interval = Ticker.where(:created_at => (current_date..current_date.at_end_of_day));
        min_max_symbol = interval
                             .select('min(price_usd) as min, max(price_usd) as max, max(id) as last_id, symbol').group(:symbol)
        count = 0
        min_max_symbol.each do |ticker|
          last = interval.where(id: ticker.last_id).first
          if last != nil and not TickerDay.exists?(last_ticker_at: last.created_at, symbol: ticker.symbol)
            TickerDay.create(symbol: ticker.symbol, min: ticker.min, max: ticker.max, price: last.price_usd, vol_24h: last.volume_usd_24h, last_ticker_at: last.created_at)
            count += 1
          end

        end
        Rails.logger.info "Created #{count} records for day #{date_to_s current_date}, destroying #{interval.size} records"
        interval.destroy_all
        current_date += 1.day
      end
    else
      Rails.logger.info "Nothing to archive"
    end
  end

  def date_to_s(date)
    date.strftime('%b-%d %H:%M')
  end
end
