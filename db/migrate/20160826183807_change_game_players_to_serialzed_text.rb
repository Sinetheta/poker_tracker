class ChangeGamePlayersToSerialzedText < ActiveRecord::Migration
  def change
    change_column :games, :players, :text
  end
end
