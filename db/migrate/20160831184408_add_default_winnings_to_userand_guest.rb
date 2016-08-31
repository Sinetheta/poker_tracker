class AddDefaultWinningsToUserandGuest < ActiveRecord::Migration
  def change
    change_column :users, :winnings, :integer, :default => 0
    change_column :guests, :winnings, :integer, :default => 0
  end
end
