class CreateLedgers < ActiveRecord::Migration[5.1]
  def change
    create_table :ledgers do |t|
      t.decimal :count, precision: 15, scale: 7, default: 0
      t.string :symbol
      t.references :trade, foreign_key: true
      t.references :user, foreign_key: true
      t.string :description

      t.timestamps
    end
  end
end
