class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :mnuid_it
      t.belongs_to :pizzapage, index: true

      t.timestamps null: false
    end
  end
end
