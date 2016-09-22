class Cart < ActiveRecord::Base

  has_many :product_orders, dependent: :destroy

end
