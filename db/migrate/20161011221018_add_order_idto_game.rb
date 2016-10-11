class AddOrderIdtoGame < ActiveRecord::Migration
  def change
    add_column :games, :saved_order_id, :integer
  end
end
