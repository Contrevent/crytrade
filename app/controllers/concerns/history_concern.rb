module HistoryConcern
  extend ActiveSupport::Concern
  include ViewModelConcern

  def history_def(width = 9)
    create_vm :history, 'history/table', width,
              Trade.where(:user => current_user, :closed => true)
  end

end