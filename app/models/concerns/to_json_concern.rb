module ToJsonConcern
  extend ActiveSupport::Concern

  def to_json(cols)
    ApplicationHelper::to_json(self, cols)
  end

end