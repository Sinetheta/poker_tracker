class Cart < ActiveRecord::Base

  require 'pizza_order_helpers.rb'

  has_many :product_orders

  def checkout
    pizza_order = PizzaOrder.new(self, Pizzapage.find(1))
    pizza_order.cart_total
  end
end
