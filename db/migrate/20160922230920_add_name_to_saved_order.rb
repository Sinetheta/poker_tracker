class AddNameToSavedOrder < ActiveRecord::Migration
  def change
    add_column :saved_orders, :name, :string
  end
end
