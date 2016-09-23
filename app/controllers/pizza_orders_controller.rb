class PizzaOrdersController < ApplicationController

  before_action :require_login
  before_action :require_config

  def new
  end

  def create
    pizza_config = current_user.pizza_config
    order = SavedOrder.find(params[:saved_order_id]).order
    if !order.nil?
      pizzapage = Pizzapage.find_by(pizza_config.pizzapage_params)
      cart = Cart.create()
      order.each do |order|
        product_name = order.keys.first()
        options = order.values.first()
        product = Product.find_by_name(product_name)
        ProductOrder.create(product: product, cart: cart, options: options)
      end
      pizza_order = PizzaOrder.new(cart: cart,
                                   pizzapage: pizzapage,
                                   cookiespath: "cookies/#{params[:order_name]}.yaml")
      pizza_order.add_cart_to_web_cart
      redirect_to pizza_checkout_path(pizza_order_id: pizza_order.id)
    else
      flash[:alert] = "Order not found"
      redirect_to pizza_path
    end
  end

  def checkout
    @pizza_order = PizzaOrder.find(params[:pizza_order_id])
    @checkout_info = @pizza_order.checkout_info.select {|line| !line.empty?}.each do |line|
      line.unshift("") if line.length == 2
    end
    @config = current_user.pizza_config
  end

  def checkout_confirm
    pizza_order = PizzaOrder.find(params[:pizza_order_id])
    pizza_order.proceed_to_checkout(current_user.pizza_config.order_info,
                                    current_user.pizza_config.delivery_info)
    flash[:alert] = "Pizza Successfully Ordered!"
    redirect_to pizza_path
  end

  private

  def require_login
    unless user_signed_in?
      flash[:alert] = "You must log in to continue"
      redirect_to new_user_session_path
    end
  end

  def require_config
    unless current_user.pizza_config
      flash[:alert] = "You must create a config before you can continue"
      redirect_to root_path
    end
  end

end
