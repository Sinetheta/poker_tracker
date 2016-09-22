class PizzaOrdersController < ApplicationController

  require 'pizzaconfig.rb'
  require 'pizza_order_helpers.rb'

  def new
  end

  def create
    pizza_config = PizzaConfig.new(params[:order_name])
    if !pizza_config.order.nil?
      pizzapage = Pizzapage.find_or_create_by(pizza_config.pizzapage_params)
      pizzapage.create_categories_and_products
      cart = Cart.create()
      pizza_config.order.each do |product_name, options|
        product = Product.find_by_name(product_name)
        ProductOrder.create(product: product, cart: cart, options: options)
      end
      pizza_order = PizzaOrder.new(cart, pizzapage, "cookies/#{params[:order_name]}.yaml")
      total = pizza_order.add_cart_to_web_cart
      redirect_to pizza_checkout_path(cartid: cart.id, pizzapageid: pizzapage.id, order_name: params[:order_name], total: total)
    else
      flash[:alert] = "Order not found"
      redirect_to pizza_path
    end
  end

  def checkout
    pizzapage = Pizzapage.find(params[:pizzapageid])
    cart = Cart.find(params[:cartid])
    pizza_order = PizzaOrder.new(cart, pizzapage, "cookies/#{params[:order_name]}.yaml")
    pizza_order.proceed_to_checkout
    render plain: params[:total]
  end

end
