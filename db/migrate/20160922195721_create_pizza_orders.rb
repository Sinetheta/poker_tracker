class CreatePizzaOrders < ActiveRecord::Migration
  def change
    create_table :pizza_orders do |t|
      t.string :cookiespath
      t.belongs_to :cart, index: true
      t.belongs_to :pizzapage, index: true

      t.timestamps null: false
    end
  end
end
