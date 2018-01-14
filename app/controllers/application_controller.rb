class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def index
    latest = Ticker.select('MAX(last_updated) as last_updated, id, symbol').group(:symbol, :id).all
    ids = latest.map{|currency| currency.id}
    @currencies = Ticker.find(ids).sort_by {|currency| -currency.score }.select{|currency| currency.score > 0}
  end
end
