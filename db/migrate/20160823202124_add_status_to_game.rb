class AddStatusToGame < ActiveRecord::Migration
  def change
    add_column :games, :status, :text, default: "inactive"
    add_column :games, :round, :integer, default: 0
  end
end
