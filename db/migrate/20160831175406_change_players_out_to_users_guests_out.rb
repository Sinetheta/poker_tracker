class ChangePlayersOutToUsersGuestsOut < ActiveRecord::Migration
  def change
    add_column :games, :users_out, :text
    rename_column :games, :players_out, :guests_out
  end
end
