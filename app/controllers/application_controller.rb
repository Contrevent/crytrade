class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include TickerConcern
  include RefConcern
  include ViewModelConcern

  def last_ticker
    TickerConcern::last_ticker_update
  end

  helper_method :last_ticker
  helper_method :ref_char
  helper_method :ref_coin
  helper_method :usd_to_ref_norm
  helper_method :usd_to_ref_fine
  helper_method :num_norm
  helper_method :num_fine
  helper_method :find_vm_by_kind
  helper_method :populate_locals

end
