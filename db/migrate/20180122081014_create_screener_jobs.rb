class CreateScreenerJobs < ActiveRecord::Migration[5.1]
  def change
    create_table :screener_jobs do |t|
      t.references :screener, foreign_key: true
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
