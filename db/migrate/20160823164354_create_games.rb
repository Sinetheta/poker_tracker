class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name
      t.integer :players
      t.integer :chips
      t.float :game_length
      t.integer :round_length
      t.integer :round, default: 0
      t.integer :first_small_blind
      t.integer :smallest_denomination
      t.text :blinds

      t.timestamps null: false
    end
  end
end
