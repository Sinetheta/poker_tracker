class AddOrderPizzaAfterRoundtoGame < ActiveRecord::Migration
  def change
    add_column :games, :order_pizza_after_round, :integer
  end
end
