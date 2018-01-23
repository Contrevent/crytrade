class ScreenerMainJob < ApplicationJob
  queue_as :default
  include TickerConcern

  def ScreenerMainJob::running
    lasts = Screener.order(:last_run_at).limit(1)
    last = lasts.any? ? lasts.last.last_run_at : (DateTime.now - 2.minute)
    unless last.is_a? Numeric
      last = (DateTime.now - 2.minute)
    end
    limit = DateTime.now
    p "ScreenerMainJob last #{last}"
    current = ((limit - last) * 24 * 60).to_i
    p "ScreenerMainJob current #{current}"
    running = current <= 1
    running
  end

  def perform(*args)
    unless ScreenerMainJob::running
      p "Starting ScreenerMainJob..."
      count = 0
      ScreenerJob.where(status: :queue).order(:created_at).each do |job|
        screener = job.screener
        where_clause = ScreenerFilter.where(screener: screener)
                           .map {|filter| "tickers.#{filter.field} #{filter.operator} #{filter.value}"}
                           .join(" and ")

        job.transaction do
          begin
            job.status = :running
            job.save
            tickers = TickerConcern::last_ticker.where(where_clause)
            tickers.each do |ticker|
              ScreenerResult.create(screener_job: job, ticker: ticker)
            end

            count = tickers.any? ? tickers.count : 0
            screener.update(last_run_at: DateTime.now, last_run_count: count, last_job_id: job.id)
            job.status = :done
            job.save
          rescue exception
            Rails.logger.warn "Exception running where clause '#{where_clause}'"
          end
        end
        count +=1
      end
    end
    p "ScreenMainJob finished: #{count} processed."
  else
    p "ScreenMainJob already running..."
  end
end
