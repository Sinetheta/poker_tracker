class PizzaOrder

  require 'mechanize'
  require 'pizzaconfig.rb'

  def initialize(cart, page, cookie_path)
    @page = page
    @cart = cart
    @cookie_path = cookie_path
  end

  def add_cart_to_web_cart
    mech = Mechanize.new()
    @cart.product_orders.each do |product_order|
      add_to_web_cart(product_order, mech)
    end
    mech.get(@page.checkout_url)
    mech.page.search("//font[starts-with(b, '$')]/b").text.gsub(/\$|\./, "").to_i/100.0
    mech.cookie_jar.save(@cookie_path)
  end

  def add_to_web_cart(product_order, mech)
    page = mech.get(product_order.product.url)
    form = page.form('crtitmfrm')

    (product_order.options[:radios] || []).each do |name, selection|
      radio = form.radiobuttons.detect {|r| r.name == name && r.text == selection}
      radio.click unless radio.nil? or radio.checked == true
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

  def web_cart_total
    mech = Mechanize.new()
    mech.cookie_jar.load(@cookie_path)
    binding.pry
    checkout_page = mech.get(@page.checkout_url)
    checkout_page.search("//font[starts-with(b, '$')]/b").text.gsub(/\$|\./, "").to_i/100.0
  end

  def proceed_to_checkout(order_info, delivery_info)
    mech = Mechanize.new()
    mech.cookie_jar.load(@cookie_path)
    checkout_page = mech.get(@page.checkout_url)
    order_info.merge!(delivery_info) unless checkout_page.search("//td[starts-with(font, 'Delivery')]/font").empty?
    checkout_page.form('crtordlfrm').field('action_ith').value = "chkoutb"
    checkout_page = checkout_page.form('crtordlfrm').submit
    checkout_page = checkout_page.link.click
    form = checkout_page.form
    order_info.each do |name, value|
      form.fields.detect {|f| f.name == name.to_s}.value = value
    end
    binding.pry
  end

end
