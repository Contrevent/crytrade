module HistoryConcern
  extend ActiveSupport::Concern
  include ViewModelConcern

  def history_def(width = 9, height = 25)
    create_vm :history, 'history/table', width, height,
              Trade.where(:user => current_user, :closed => true)
  end

end