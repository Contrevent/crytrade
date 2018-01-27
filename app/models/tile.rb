class Tile < ApplicationRecord
  belongs_to :user
  enum kind: {
      screener_last: 'Screener',
      coins: 'Coins',
      funds: 'Funds',
      trade: 'Trades (Main)',
      trade_ticker: 'Trades (Tickers)',
      history: 'History'
  }
end
