class CreateScreenerFilters < ActiveRecord::Migration[5.1]
  def change
    create_table :screener_filters do |t|
      t.references :screener, foreign_key: true
      t.string :field
      t.string :type
      t.string :operator
      t.string :value

      t.timestamps
    end
  end
end
