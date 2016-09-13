class AddSavedTimerToGames < ActiveRecord::Migration
  def change
    add_column :games, :saved_timer, :integer
  end
end
