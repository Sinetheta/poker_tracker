class AddBuyInToGames < ActiveRecord::Migration
  def change
    add_column :games, :buy_in, :integer
  end
end
