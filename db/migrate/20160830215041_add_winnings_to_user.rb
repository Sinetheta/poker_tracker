class AddWinningsToUser < ActiveRecord::Migration
  def change
    add_column :users, :winnings, :integer
  end
end
