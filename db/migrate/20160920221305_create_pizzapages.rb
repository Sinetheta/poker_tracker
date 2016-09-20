class CreatePizzapages < ActiveRecord::Migration
  def change
    create_table :pizzapages do |t|
      t.string :webpage_path
      t.string :menu_path
      t.string :item_path
      t.string :checkout_path

      t.timestamps null: false
    end
  end
end
