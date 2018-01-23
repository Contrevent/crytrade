class ScreenerResult < ApplicationRecord
  belongs_to :screener_job
  belongs_to :ticker
end
