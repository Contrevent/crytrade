class LedgerController < ApplicationController
  include LedgerConcern
  before_action :authenticate_user!

  def index
    @entries = Ledger.where(:user => current_user).order('created_at desc')
    @symbols = TickerConcern.symbols
    @entry = Ledger.new
    @balance = balance
    @tab = 'index'
  end

  def update
    @entries = Ledger.where(:user => current_user).order('created_at desc')
    @entry = Ledger.find(params[:id])
  end

  def deposit
    @entry = Ledger.create(ledger_params)
    @entry.user = current_user
    if @entry.save
      flash[:notice] = "Deposit created."
      redirect_to action: 'index'
    else
      @entries = Ledger.where(:user => current_user).order('created_at desc')
      @symbols = TickerConcern.symbols
      @balance = balance
      @tab = 'deposit'
      render 'index'
    end
  end

  def withdraw
    @entry = Ledger.create(ledger_params)
    @entry.count = -@entry.count
    @entry.user = current_user
    if @entry.save
      flash[:notice] = "Deposit created."
      redirect_to action: 'index'
    else
      @entries = Ledger.where(:user => current_user).order('created_at desc')
      @symbols = TickerConcern.symbols
      @balance = balance
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
end
