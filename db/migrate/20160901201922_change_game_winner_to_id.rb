class ChangeGameWinnerToId < ActiveRecord::Migration
  def change
    rename_column :games, :winner, :winner_id
    change_column :games, :winner_id, :integer
  end
end
