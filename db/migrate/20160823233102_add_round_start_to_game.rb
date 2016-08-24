class AddRoundStartToGame < ActiveRecord::Migration
  def change
    add_column :games, :round_start, :datetime
  end
end
