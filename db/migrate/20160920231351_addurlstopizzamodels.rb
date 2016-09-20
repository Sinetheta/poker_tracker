class Addurlstopizzamodels < ActiveRecord::Migration
  def change
    add_column :pizzapages, :url, :string
    add_column :categories, :url, :string
    add_column :products, :url, :string
  end
end
