class FiatTickerJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Fiat.all.each do |fiat|
      if Currency.exists? symbol: fiat.symbol
        cur = Currency.find(symbol: fiat.symbol)
        cur.price_usd = fiat.price_usd
        cur.save
      else
        Currency.create(symbol: fiat.symbol, name: fiat.name, price_usd: fiat.price_usd)
      end
    end
  end
end
