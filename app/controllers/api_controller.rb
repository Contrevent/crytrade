class ApiController < ApplicationController
  include TickerConcern
  include ScreenerConcern
  include RefConcern
  include ActionView::Helpers::DateHelper

  def ticker_price
    if params.key?(:symbol)
      price_usd = TickerConcern::last_price_usd(params[:symbol])
      price = price_usd != -1 ? ref_value(price_usd) : 0
      render json: {'price': num_fine(price), 'currency': ref_coin}
    else
      render text: "Bad Request", status: 400
    end
  end

  def ticker_update
    react_view 'TickerUpdate', {label: time_ago_in_words(last_ticker)}, 15
  end

  def coins
    react_coins
  end

end
