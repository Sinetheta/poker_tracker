class Cart < ActiveRecord::Base

  require 'pizza_order_helpers.rb'

  has_many :product_orders, dependent: :destroy

end
