class LedgerController < ApplicationController
  include LedgerConcern
  include ScreenerConcern
  include ViewModelConcern
  include FacetsConcern

  before_action :authenticate_user!

  def index
    if request.format == :json
      ledger_entries
    else
      index_facets :funds
    end
  end

  def show
    entry = Ledger.find(params[:id])
    if entry != nil
      item_facets :destroy_ledger, entry
    else
      render status: 404
    end
  end

  def deposit
    transaction :deposit, 'Deposit'
  end

  def withdraw
    transaction :withdraw, 'Withdraw', false
  end

  def regul
    entry = Ledger.create(ledger_params)
    entry.user = current_user
    ok = false
    if entry.valid?
      input_count = entry.count
      current_balance = Ledger.where(user: current_user, symbol: entry.symbol).sum(:count)
      diff = input_count - current_balance
      entry.count = diff
      if entry.save
        flash[:notice] = "Regulation created."
        redirect_to action: 'index'
        ok = true
      end
    end
    unless ok
      index_facets :regul, entry
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
  def index_facets(active, entry = nil)
    @facets = activate active, ledger_facet, funds_facet, deposit_facet(entry),
                       withdraw_facet(entry), regul_facet(entry)
  end

  def deposit_facet(entry = nil)
    facet(:deposit, 'Deposit', nil, deposit_def(entry), false, 'success')
  end

  def deposit_def(entry = nil)
    create_vm :deposit, 'ledger/create', 0, 0, entry != nil ? entry : Ledger.new,
              {url: ledger_deposit_url, prefix: 'ct-dep', kind: 'success', label: 'Deposit'}
  end

  def withdraw_facet(entry = nil)
    facet(:withdraw, 'Withdraw', nil, withdraw_def(entry), false, 'danger')
  end

  def withdraw_def(entry = nil)
    create_vm :deposit, 'ledger/create', 0, 0, entry != nil ? entry : Ledger.new,
              {url: ledger_withdraw_url, prefix: 'ct-wit', kind: 'danger', label: 'Withdraw'}
  end

  def regul_facet(entry = nil)
    facet(:regul, 'Regulation', nil, regul_def(entry), false, 'info')
  end

  def regul_def(entry = nil)
    create_vm :regul, 'ledger/regul', 0, 0, entry != nil ? entry : Ledger.new
  end

  def ledger_facet
    facet(:ledger, 'Ledger', nil, ledger_def, true, 'primary')
  end

  def ledger_def
    create_vm :ledger, 'ledger/table', 0, 0, nil
  end

  def item_facets(active, entry)
    @facets = activate active, ledger_facet, destroy_ledger_facet(entry), back_facet
  end

  def destroy_ledger_facet(entry)
    facet(:destroy_ledger, 'Delete', nil, destroy_ledger_def(entry), false, 'danger')
  end

  def destroy_ledger_def(entry)
    create_vm :destroy_ledger, 'shared/delete', 0, 0, nil,
              {url: ledger_destroy_path(id: entry.id)}
  end

  def back_facet
    facet(:back, 'Back', ledger_url)
  end


  def ledger_entries
    cols = ledger_columns
    data = entries.map {|obj| ApplicationHelper::to_json(obj, cols)}
    react_view 'Ledger', {cols: cols.map {|col| col_to_json(col)},
                          data: data, order: {field: 'date', dir: 'desc'}}, 0
  end

  def transaction(symbol, label, deposit = true)
    entry = Ledger.create(ledger_params)
    entry.user = current_user
    ok = false
    if entry.valid?
      unless deposit
        entry.count = -entry.count
      end
      if entry.save
        flash[:notice] = "#{label} created."
        redirect_to action: 'index'
        ok = true

      end
    end

    unless ok
      p "#{entry.errors.count} Error while creating #{label}"
      index_facets(symbol, entry)
      render 'index'
    end
  end

  def ledger_params
    params.require(:entry).permit(:symbol, :count, :description)
  end

end
