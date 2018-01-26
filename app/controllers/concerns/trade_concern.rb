module TradeConcern
  extend ActiveSupport::Concern
  include ViewModelConcern

  def trade_def(width = 9)
    create_vm :trade, 'trade/table', width,
              Trade.where(:user => current_user, :closed => false)
  end

end