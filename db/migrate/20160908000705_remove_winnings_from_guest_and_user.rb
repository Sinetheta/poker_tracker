class RemoveWinningsFromGuestAndUser < ActiveRecord::Migration
  def change
    remove_column :users, :winnings
    remove_column :guests, :winnings
  end
end
