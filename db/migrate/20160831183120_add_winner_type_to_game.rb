class AddWinnerTypeToGame < ActiveRecord::Migration
  def change
    add_column :games, :winner_type, :string
  end
end
