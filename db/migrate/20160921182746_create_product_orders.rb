class CreateProductOrders < ActiveRecord::Migration
  def change
    create_table :product_orders do |t|
      t.belongs_to :product, index: true
      t.text :options

      t.timestamps null: false
    end
  end
end
