class CreateScreenerResults < ActiveRecord::Migration[5.1]
  def change
    create_table :screener_results do |t|
      t.references :screener_job, foreign_key: true
      t.references :ticker, foreign_key: true

      t.timestamps
    end
  end
end
