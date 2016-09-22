class PizzaOrdersController < ApplicationController

  require 'pizzaconfig.rb'

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
      pizza_order = PizzaOrder.new(cart: cart, pizzapage: pizzapage, cookiespath: "cookies/#{params[:order_name]}.yaml")
      pizza_order.add_cart_to_web_cart
      pizza_order.save
      redirect_to pizza_checkout_path(pizza_order_id: pizza_order.id)
    else
      flash[:alert] = "Order not found"
      redirect_to pizza_path
    end
  end

  def checkout
    @pizza_order = PizzaOrder.find(params[:pizza_order_id])
  end

  def checkout_confirm
    pizza_order = PizzaOrder.find(params[:pizza_order_id])
    pizza_config = PizzaConfig.new("")
    pizza_order.proceed_to_checkout(pizza_config)
    flash[:alert] = "Pizza Successfully Ordered!"
    redirect_to pizza_path
  end

end
