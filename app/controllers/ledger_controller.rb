class LedgerController < ApplicationController
  include LedgerConcern
  include ScreenerConcern
  include ViewModelConcern

  before_action :authenticate_user!

  def index
    define_locals_index
    @entry = Ledger.new
    @tab = 'index'
  end

  def update
    define_locals
    @entry = Ledger.find(params[:id])
  end

  def ticker
    order_name, order_direction = TickerConcern::parse_order params
    populate funds_def(3), funds_tickers_def(order_name, order_direction, 9)
  end

  def deposit
    @entry = Ledger.create(ledger_params)
    @entry.user = current_user
    if @entry.save
      flash[:notice] = "Deposit created."
      redirect_to action: 'index'
    else
      p "#{@entry.errors.count} Error while creating deposit"
      define_locals_index
      @tab = 'deposit'
      render 'index'
    end
  end

  def withdraw
    @entry = Ledger.create(ledger_params)
    @entry.count = -@entry.count
    @entry.user = current_user
    if @entry.save
      flash[:notice] = "Withdraw created."
      redirect_to action: 'index'
    else
      define_locals_index
      @tab = 'withdraw'
      render 'index'
    end
  end

  def regul
    @entry = Ledger.create(ledger_params)
    @entry.user = current_user
    input_count = @entry.count
    current_balance = Ledger.where(user: current_user, symbol: @entry.symbol).sum(:count)
    diff = input_count - current_balance
    @entry.count = diff
    if @entry.save
      flash[:notice] = "Regulation created."
      redirect_to action: 'index'
    else
      define_locals_index
      @entry.count = input_count
      @tab = 'regul'
      render 'index'
    end
  end

  def destroy
    trade = Ledger.find(params[:id])
    if trade != nil
      trade.destroy
      flash[:notice] = "Entry deleted."
    end
    redirect_to action: 'index'
  end

  def funds
    order_name = 'count_ref'
    order_direction = 'desc'
    cols = funds_columns
    data = balance.map {|obj| ApplicationHelper::to_json(obj, cols)}
    react_view 'Funds', {cols: cols.map {|col| col_to_json(col)},
                         data: data, order: {field: order_name, dir: order_direction}}, 30
  end

  private
  def ledger_params
    params.require(:entry).permit(:symbol, :count, :description)
  end

  def define_locals
    @entries = entries
  end

  def define_locals_index
    define_locals
    populate funds_def
  end
end
