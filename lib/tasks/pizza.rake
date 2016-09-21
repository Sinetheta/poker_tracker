require 'pizzaconfig.rb'

namespace :db do
  desc "Seed Pizza Page"
  task seed_pizza: :environment do
    pizzapage = Pizzapage.create(PizzaConfig::PIZZAPAGE_PARAMS)
    pizzapage.create_categories_and_products
    cart = Cart.create()
    PizzaConfig::ORDER.each do |product_name, options|
      product = Product.find_by_name(product_name)
      ProductOrder.create(product: product, cart: cart, options: options)
    end
  end
end
