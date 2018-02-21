class RemoveConverterFromDashboard < ActiveRecord::Migration[5.1]
  def up
    Tile.where(:kind => 'Converter').destroy_all
  end
end
