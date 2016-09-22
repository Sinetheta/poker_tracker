require 'pizzaconfig.rb'
require 'pizza_order_helpers.rb'

namespace :pizza do
  desc "Place a pizza order"
  task pizza_order: :environment do
    puts "Enter the name of the order"
    order_name = STDIN.gets.chomp
    pizzaconfig = PizzaConfig.new(order_name)
    pizzapage = Pizzapage.find_or_create_by(pizzaconfig.pizzapage_params)
    binding.pry
    pizzapage.create_categories_and_products
    cart = Cart.create()
    pizzaconfig.order.each do |product_name, options|
      product = Product.find_by_name(product_name)
      ProductOrder.create(product: product, cart: cart, options: options)
    end
    puts pizzaconfig.order_info
    puts pizzaconfig.order
    puts "Please confirm the above information"
    puts "Enter (y) to continue and see cart total"
    answer = STDIN.gets.chomp
    if answer == "y"
      pizza_order = PizzaOrder.new(cart, pizzapage)
      puts pizza_order.web_cart_total
      puts "Is the above total correct? Enter (y) to checkout"
      confirm = STDIN.gets.chomp
      if confirm == "y"
        pizza_order.proceed_to_checkout(pizzaconfig.order_info, pizzaconfig.delivery_info)
      end
    end
    cart.destroy
  end
end
