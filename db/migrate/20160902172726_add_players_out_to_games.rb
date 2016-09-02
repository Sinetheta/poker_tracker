class AddPlayersOutToGames < ActiveRecord::Migration
  def change
    add_column :games, :players_out, :text
  end
end
