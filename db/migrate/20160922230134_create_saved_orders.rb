class CreateSavedOrders < ActiveRecord::Migration
  def change
    create_table :saved_orders do |t|
      t.text :order
      t.belongs_to :user, index: true

      t.timestamps null: false
    end
  end
end
