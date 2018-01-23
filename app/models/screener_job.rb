class ScreenerJob < ApplicationRecord
  belongs_to :screener
  enum status: {queue: 0, cancel: -1, running: 1, done: 2}
end
