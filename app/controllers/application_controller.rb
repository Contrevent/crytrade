class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include TickerConcern
  include RefConcern
  include ViewModelConcern

  def last_ticker
    TickerConcern::last_ticker_update
  end

  def dash_on
    Rails.cache.fetch('#cry_trade/dash_on', expires_in: 1.minute) do
      user_signed_in? and Tile.where(user: current_user).any?
    end
  end

  helper_method :dash_on
  helper_method :kind_options
  helper_method :last_ticker
  helper_method :ref_char
  helper_method :ref_coin
  helper_method :usd_to_ref_norm
  helper_method :usd_to_ref_fine
  helper_method :num_norm
  helper_method :num_fine
  helper_method :find_vm_by_kind
  helper_method :populate_locals
  helper_method :coin_symbols

  protected

  def react_view(component, props, interval = 0)
    render json: {component: component, props: props, interval: interval}
  end

end
