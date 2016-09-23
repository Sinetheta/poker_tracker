class PizzaConfig < ActiveRecord::Base

  belongs_to :user

  after_save :create_pizzapage_and_products

  def pizzapage_params
    {webpage_path: self.webpage_path,
     menu_path: self.menu_path,
     item_path: self.item_path,
     checkout_path: self.checkout_path}
  end

  def order_info
    {fn_it: self.first_name,
     ln_it: self.last_name,
     php1_it: self.phone_number[0...3],
     php2_it: self.phone_number[3...6],
     php3_it: self.phone_number[6...10],
     ordshpreml: self.email,
     onote: self.ordernote}
  end

  def delivery_info
    {adstr_it: self.address,
     ordshprcmp: self.company,
     orddelbuzno: self.buzzer,
     adcti_it: self.city,
     adz_it: self.postal_code,
     pttid: determine_payment_selection(self.payment_method)}
  end

  def determine_payment_selection(name)
    case name
    when "Cash"
      0
    when "Visa"
      2
    when "Mastercard"
      3
    when "American Express"
      4
    when "Gift Card"
      9
    else
      10
    end
  end

  private

  def create_pizzapage_and_products
    pizzapage = Pizzapage.find_or_create_by(self.pizzapage_params)    
    pizzapage.create_categories_and_products
  end
end
