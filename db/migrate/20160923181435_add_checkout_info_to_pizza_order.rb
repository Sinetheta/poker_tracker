class AddCheckoutInfoToPizzaOrder < ActiveRecord::Migration
  def change
    add_column :pizza_orders, :checkout_info, :text
  end
end
