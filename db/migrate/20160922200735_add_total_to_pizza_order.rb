class AddTotalToPizzaOrder < ActiveRecord::Migration
  def change
    add_column :pizza_orders, :total, :decimal
  end
end
