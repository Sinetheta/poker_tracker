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

  # Create a random pizza order
  def random_order
    # Params: size of pizza, number of pizzas
    # select out pizzas
    size = 2
    qty = 2
    selection = []
    pizzas = get_pizzas
    pizzas.reject! {|pizza| pizza.name == "Create Your Own Pizza"}
    qty.times { selection << pizzas.sample }
    # check we have product options available
    selection.each do |pizza|
      pizza.generate_options if pizza.options == {}
    end
    selection.map! {|pizza| configure_pizza(pizza, size)}.flatten!
    SavedOrder.create(name: "random", user_id: current_user.id, order: selection)
    redirect_to pizza_path
  end

  def create_pizza
    @pizzas = get_pizzas
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

  def get_pizzas
    pizzas = []
    pizza_categories = Category.select {|category| category.name == "classic" || category.name == "premium"}
    pizza_categories.each do |category|
      category.products.each do |product|
        pizzas << product
      end
    end
    pizzas.sort_by! {|pizza| (pizza.options[:checkboxes]["mcctsuids"] || []).length}
  end

  def configure_pizza(pizza, size)
    options = pizza.options
    options.delete(:checkboxes)
    options.delete(:text_fields)
    options[:radios].delete("mcctstids3")
    options[:radios]["olszid"] = options[:radios]["olszid"][size]
    options[:radios]["mcctstids1"] = options[:radios]["mcctstids1"][0]
    options[:radios]["mcctstids2"] = options[:radios]["mcctstids2"][0]
    options[:radios]["otid"] = options[:radios]["otid"][0]
    [pizza.name => options]
  end

end
