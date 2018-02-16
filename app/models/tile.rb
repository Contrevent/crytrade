class Tile < ApplicationRecord
  belongs_to :user
  enum kind: {
      screener_last: 'Screener',
      coins: 'Coins',
      funds: 'Funds',
      funds_tickers: 'Funds (Tickers)',
      trade: 'Trades (Main)',
      trade_ticker: 'Trades (Tickers)',
      history: 'History',
      converter: 'Converter'
  }
end
