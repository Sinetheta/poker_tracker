class RemoveUsersabdGuestsOutfromGame < ActiveRecord::Migration
  def change
    remove_column :games, :users_out
    remove_column :games, :guests_out
  end
end
