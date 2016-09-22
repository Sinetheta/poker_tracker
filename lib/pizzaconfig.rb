require 'yaml'

class PizzaConfig

  attr_reader :pizzapage_params, :order_info, :delivery_info, :order

  def initialize(order_name)
    @pizzapage_params= {webpage_path: "",
                        menu_path: "",
                        item_path: "",
                        checkout_path: ""}

    @order_info = {fn_it: "", ln_it: "",
                   php1_it: "", php2_it: "", php3_it: "",
                   ordshpreml: "", onote: "Please call to confirm order"}

    @delivery_info = {adstr_it: "", orddlvaptsut: "", orddelbuzno: "", adcti_it: "",
                      adz_it: "", pttid: "10"}

    @order = get_order(order_name)
  end

  def get_order(order_name)
    path = "orders/custom_orders/#{order_name}.yaml"
    if File.exist?(path)
      YAML::load(File.open(path, "r").read)
    else
      nil
    end
  end
end

