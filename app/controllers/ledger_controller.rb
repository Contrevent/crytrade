class LedgerController < ApplicationController
  include LedgerConcern

  def index
    @entries = Ledger.where(:user => current_user)
    @symbols = TickerConcern.symbols
    @entry = Ledger.new
    @balance = balance
  end

  def update
    @entries = Ledger.where(:user => current_user)
    @entry = Ledger.find(params[:id])
  end

  def deposit
    dep_params = ledger_params
    if dep_params.permitted?
      entry = Ledger.create(dep_params)
      entry.user = current_user
      entry.save
      flash[:notice] = "Deposit created."
      redirect_to action: 'index'
    else
      flash[:error] = "Invalid values."
    end
  end

  def withdraw
    dep_params = ledger_params
    if dep_params.permitted?
      entry = Ledger.create(dep_params)
      entry.count = -entry.count
      entry.user = current_user
      entry.save
      flash[:notice] = "Withdraw created."
      redirect_to action: 'index'
    else
      flash[:error] = "Invalid values."
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
