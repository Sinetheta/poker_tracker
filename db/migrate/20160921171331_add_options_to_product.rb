class AddOptionsToProduct < ActiveRecord::Migration
  def change
    add_column :products, :options, :text
  end
end
