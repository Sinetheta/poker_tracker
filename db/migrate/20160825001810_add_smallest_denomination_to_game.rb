class AddSmallestDenominationToGame < ActiveRecord::Migration
  def change
    add_column :games, :smallest_denomination, :integer
  end
end
