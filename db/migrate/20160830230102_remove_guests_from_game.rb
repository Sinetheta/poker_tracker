class RemoveGuestsFromGame < ActiveRecord::Migration
  def change
    remove_column :games, :guests
  end
end
