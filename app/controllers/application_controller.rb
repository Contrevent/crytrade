class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include TickerConcern

  def last_ticker
    TickerConcern::last_ticker_update
  end

  helper_method :last_ticker

end
