class PizzaOrder

  require 'mechanize'
  require 'pizzaconfig.rb'

  def initialize(cart, page)
    @mech = Mechanize.new
    @page = page
    cart.product_orders.each do |product_order|
      add_to_cart(product_order)
    end
  end

  def add_to_cart(product_order)
    page = @mech.get(product_order.product.url)
    form = page.form('crtitmfrm')
    product_order.options[:radios].each do |name, selection|
      radio = form.radiobuttons.detect {|r| r.name == name && r.text == selection}
      radio.click unless radio.checked == true
    end
    (product_order.options[:checkboxes] || []).each do |name, selections|
      selections.each do |selection|
        checkbox = form.checkboxes.detect {|c| c.name == name && c.text == selection}
        checkbox.click
      end
    end
    (product_order.options[:text_fields] || []).each do |name, value|
      text_field = form.fields.detect {|f| f.name == name}
      text_field.value = value
    end
    form.submit
  end

  def cart_total
    checkout_page = @mech.get(@page.checkout_url)
    checkout_page.search("//font[starts-with(b, '$')]/b").text.gsub(/\$|\./, "").to_i/100.0
  end

  def proceed_to_checkout
    checkout_page = @mech.get(@page.checkout_url)
    checkout_page.form('crtordlfrm').field('action_ith').value = "chkoutb"
    checkout_page = checkout_page.form('crtordlfrm').submit
    checkout_page = checkout_page.link.click
    form = checkout_page.form
    PizzaConfig::ORDER_INFO.each do |name, value|
      form.fields.detect {|f| f.name == name.to_s}.value = value
    end
    binding.pry
  end

end
