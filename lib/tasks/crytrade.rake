namespace :crytrade do
  desc "Coin market cap ticker update"
  task ticker: :environment do
    CmcTickerJob.perform_now
  end

  task fiat: :environment do
    FiatTickerJob.perform_now
  end

  task archive: :environment do
    TickerArchiveJob.perform_now
  end

end
