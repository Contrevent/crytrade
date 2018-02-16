class HomeController < ApplicationController
  include TickerConcern
  include ScreenerConcern
  include ViewModelConcern

  def index

  end

  def about

  end

  def convert

  end

  def refresh
    CmcTickerJob.perform_now
    if params.key? :c and params.key? :a
      redirect_to controller: params[:c], action: params[:a]
    else
      redirect_to action: 'index'
    end
  end


end
