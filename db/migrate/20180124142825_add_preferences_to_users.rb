class AddPreferencesToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :reference_symbol, :string, {:default => 'USD'}
    add_column :users, :reference_character, :string, {:default => '$'}
    add_column :users, :reference_precision, :integer, {:default => 2}
  end
end
