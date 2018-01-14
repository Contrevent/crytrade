namespace :crytrade do
  desc "Coin market cap ticker update"
  task ticker: :environment do
    CmcTickerJob.perform_now
  end

end
