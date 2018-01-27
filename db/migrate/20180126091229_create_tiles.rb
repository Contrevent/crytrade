class CreateTiles < ActiveRecord::Migration[5.1]
  def change
    create_table :tiles do |t|
      t.references :user, foreign_key: true
      t.string :kind
      t.integer :ref_id
      t.integer :width
      t.integer :height
      t.integer :position

      t.timestamps
    end
  end
end
