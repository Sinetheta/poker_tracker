class AddStartingBlindToGame < ActiveRecord::Migration
  def change
    add_column :games, :first_small_blind, :integer
  end
end
