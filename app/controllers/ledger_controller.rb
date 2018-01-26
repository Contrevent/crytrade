class LedgerController < ApplicationController
  include LedgerConcern
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

  def destroy
    trade = Ledger.find(params[:id])
    if trade != nil
      trade.destroy
      flash[:notice] = "Entry deleted."
    end
    redirect_to action: 'index'
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
    @symbols = TickerConcern.symbols
    populate funds_def
  end
end
