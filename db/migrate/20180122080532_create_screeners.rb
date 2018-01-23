class CreateScreeners < ActiveRecord::Migration[5.1]
  def change
    create_table :screeners do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.datetime :last_run_at
      t.integer :last_run_count
      t.integer :last_job_id, default: -1
      t.boolean :refresh, default: false

      t.timestamps
    end
  end
end
