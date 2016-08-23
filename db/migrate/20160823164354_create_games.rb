class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name
      t.integer :players
      t.integer :chips
      t.integer :game_length
      t.integer :round_length
      t.text :blinds

      t.timestamps null: false
    end
  end
end
