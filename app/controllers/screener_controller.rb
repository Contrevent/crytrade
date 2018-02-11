class ScreenerController < ApplicationController
  include TickerConcern
  include ScreenerConcern
  include ViewModelConcern
  before_action :authenticate_user!

  def index
    @screeners = Screener.where(user: current_user)
    @entry = Screener.new
  end

  def configure
    @screeners = Screener.where(user: current_user)
    @entry = Screener.new
  end

  def new
    @entry = Screener.create(new_params)
    @entry.user = current_user
    if @entry.save
      flash[:notice] = "Screener created."
      redirect_to action: 'update', id: @entry.id
    else
      @screeners = Screener.where(user: current_user)
      render action: 'configure'
    end
  end

  def edit
    @entry = Screener.find(params[:id])
    if @entry.update(edit_params)
      flash[:notice] = "Screener updated."
      redirect_to action: 'update', id: @entry.id
    else
      @screeners = Screener.where(user: current_user)
      render action: 'configure'
    end
  end

  def queue
    entry = Screener.find(params[:id])
    if entry != nil
      ScreenerJob.create(screener: entry, status: :queue)
    end
    redirect_to action: 'index'
  end

  def cancel
    entry = ScreenerJob.find(params[:id])
    if entry != nil
      entry.status = :cancel
      entry.save
    end
    redirect_to action: 'index'
  end

  def update
    @screeners = Screener.where(user: current_user)
    @entry = Screener.find(params[:id])
    @filters = filters(@entry)
    @filter = ScreenerFilter.new
    @filter.screener = @entry

    @fields = get_fields
    @filter_action = 'new'
  end

  def new_filter
    @filter = ScreenerFilter.create(new_filter_params)
    if @filter.save
      redirect_to action: 'update', id: @filter.screener_id
    else
      @screeners = Screener.where(user: current_user)
      @entry = Screener.find(params[:id])
      @filters = filters(@entry)
      render 'update'
    end
  end

  def update_filter
    @screeners = Screener.where(user: current_user)
    @entry = Screener.find(params[:screener_id])
    @filters = filters(@entry)
    @filter = ScreenerFilter.find(params[:id])

    @fields = get_fields
    @filter_action = 'edit'
    render 'update'
  end

  def edit_filter
    @filter = ScreenerFilter.find(params[:id])
    if @filter.update(edit_filter_params)
      redirect_to action: 'update', id: @filter.screener_id
    else
      @screeners = Screener.where(user: current_user)
      @entry = Screener.find(params[:id])
      @filters = filters(@entry)
      render 'update'
    end
  end

  def destroy_filter
    screener_filter = ScreenerFilter.find(params[:id])
    if screener_filter != nil
      screener_filter.destroy
    end
    redirect_to action: 'update', id: params[:screener_id]
  end

  def destroy
    screener = Screener.find(params[:id])
    if screener != nil
      screener.destroy
    end
    redirect_to action: 'configure'
  end

  def run
    @screeners = Screener.where(user: current_user)
  end

  def view
    if request.format == :json
      job_id = params[:id]
      react_coins_view job_id
    else
      order_name, order_direction = TickerConcern::parse_order params
      populate screener_view_def(params[:id], order_name, order_direction, 12)
      @view = :screener_view
    end
  end

  def last
    if request.format == :json
      screener_id = params[:id]
      react_coins_last screener_id
    else
      order_name, order_direction = TickerConcern::parse_order params
      populate screener_last_def(params[:id], order_name, order_direction, 12)
      @view = :screener_last
      render 'view'
    end
  end

  def trades
    react_coins_trades
  end

  def funds
    react_coins_funds
  end


  protected

  def run_jobs(screener)
    ScreenerJob.where('screener_id = ? and status != ? ', screener.id, -1).order('created_at desc').limit(3)
  end

  helper_method :run_jobs

  def run_results(job)
    ScreenerResult.where(screener_job: job)
  end

  helper_method :run_results

  def order_path(col, dir, id)
    screener_last_path(col: col, dir: dir, id: id)
  end

  helper_method :order_path

  def filters(screener)
    ScreenerFilter.where(screener: screener).map {|item| decorate_screener(item)}
  end

  def decorate_screener(screener)
    select = fields.select {|item| item[:field].to_s == screener.field}
    label = select.any? ? select.first[:label] : screener.field
    screener.as_json.merge({label: label})
  end

  def get_fields
    fields.map {|elt| [elt[:label], elt[:field]]}
  end

  def fields
    [{field: :volume_usd_24h, label: '24h Volume ($)'},
     {field: :market_cap_usd, label: 'Market Cap. ($)'},
     {field: :percent_change_1h, label: 'Change 1h (%)'},
     {field: :percent_change_24h, label: 'Change 24h (%)'},
     {field: :percent_change_7d, label: 'Change 7d (%)'},
     {field: :rank, label: 'Rank'},
     {field: :price_usd, label: 'Price ($)'},
     {field: :price_btc, label: 'Price (BTC)'},
    ]
  end

  def new_params
    params.require(:entry).permit(:name)
  end

  def edit_params
    params.require(:entry).permit(:name, :refresh)
  end

  def new_filter_params
    params.require(:filter).permit(:screener_id, :field, :operator, :value)
  end

  def edit_filter_params
    params.require(:filter).permit(:screener_id, :field, :operator, :value)
  end

end
