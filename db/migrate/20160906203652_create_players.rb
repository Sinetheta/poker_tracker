class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.belongs_to :game, index: true
      t.references :guest
      t.references :user

      t.timestamps null: false
    end

    add_reference :users, :player, index: true
    add_reference :guests, :player, index: true
  end
end
