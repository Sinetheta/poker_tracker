class Addproductsmodel < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.integer :iid_it
      t.belongs_to :category, index: true

      t.timestamps null: false
    end
  end
end
