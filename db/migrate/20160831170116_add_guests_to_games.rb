class AddGuestsToGames < ActiveRecord::Migration
  def change
    create_table :games_guests, id: false do |t|
      t.belongs_to :guest, index: true
      t.belongs_to :game, index: true
    end
  end
end
