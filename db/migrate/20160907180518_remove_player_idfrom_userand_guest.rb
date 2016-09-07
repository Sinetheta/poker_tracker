class RemovePlayerIdfromUserandGuest < ActiveRecord::Migration
  def change
    remove_column :users, :player_id
    remove_column :guests, :player_id
  end
end
