class RemoveExtraColumnsFromGame < ActiveRecord::Migration
  def change
    remove_column :games, :winner_id
    remove_column :games, :winner_type
    remove_column :games, :players_out
    add_column :games, :complete, :boolean
  end
end
