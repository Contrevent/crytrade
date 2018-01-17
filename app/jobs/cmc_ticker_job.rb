class CmcTickerJob < ApplicationJob
  queue_as :default

  def perform(*args)
    begin
      response = RestClient::Request.execute(url: 'https://api.coinmarketcap.com/v1/ticker/', method: :get,
                                             headers: {content_type: :json, accept: :json}, verify_ssl: false)
      parsed_json = JSON.parse response.body
      total_count = 0
      update_count = 0
      parsed_json.each do |currency|
        unless Ticker.exists?(:currency_id => currency['id'], :last_updated => currency['last_updated'])
          Ticker.create!(:currency_id => currency['id'], :currency_name => currency['name'],
                         :symbol => currency['symbol'], :rank => currency['rank'],
                         :price_usd => currency['price_usd'], :price_btc => currency['price_btc'],
                         :volume_usd_24h => currency['24h_volume_usd'], :market_cap_usd => currency['market_cap_usd'],
                         :available_supply => currency['available_supply'], :total_supply => currency['total_supply'],
                         :max_supply => currency['max_supply'], :percent_change_1h => currency['percent_change_1h'],
                         :percent_change_24h => currency['percent_change_24h'], :percent_change_7d => currency['percent_change_7d'],
                         :last_updated => currency['last_updated'])
          update_count += 1
        end
          total_count += 1
      end
      p "Tickers updated #{update_count} out of #{total_count}"
    rescue Exception => e
        Rails.logger.warn("An exception occurred while retrieving coin market cap ticker: #{e.message}")
    end


    Ticker.select(:symbol, :currency_name).distinct(:symbol).each do |ticker|
      unless Currency.exists? symbol: ticker.symbol
        Currency.create(symbol: ticker.symbol, name: ticker.currency_name)
      end
    end

    Ticker.joins('INNER JOIN (select MAX(last_updated) as last_updated, symbol from tickers group by symbol) grouped_tk on tickers.symbol = grouped_tk.symbol and tickers.last_updated = grouped_tk.last_updated').each do |ticker|
      currency = Currency.find_by_symbol(ticker.symbol)
      currency.price_usd= ticker.price_usd
      currency.save
    end

  end
end
