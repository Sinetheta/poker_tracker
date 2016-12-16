class PizzaOrder < ActiveRecord::Base
  require 'mechanize'

  serialize :checkout_info, Array

  belongs_to :cart
  belongs_to :pizzapage

  def add_cart_to_web_cart
    mech = Mechanize.new()
    self.cart.product_orders.each do |product_order|
      product_page = mech.get(product_order.product.url)
      form = product_page.form('crtitmfrm')

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
    checkout_page = mech.get(self.pizzapage.checkout_url)
    self.checkout_info = checkout_page.search("//td[starts-with(font, '$') or starts-with(font, '($')]").map do |td|
      td.parent.search(".//font[@color='#000000' or @color='#95221d']").to_html.gsub(/\t|\n|<i>|<\/i>|<b>|<\/b>|<\/font>$| color=\"#000000\"| color=\"#95221d\"|<a href=\".*\">|<\/a>|[  ]{2,}/, '').gsub(/^<font>/, "").split("</font><font>")
    end
    self.total = checkout_page.search("//font[starts-with(b, '$')]/b").text.gsub(/\$|\./, "").to_i/100.0
    checkout_page.form('crtordlfrm').field('action_ith').value = "chkoutb"
    checkout_page = checkout_page.form('crtordlfrm').submit
    checkout_page = checkout_page.link.click
    mech.cookie_jar.save(self.cookiespath, session: true)
    self.save
  end

  def proceed_to_checkout(order_info, delivery_info)
    mech = Mechanize.new()
    mech.cookie_jar.load(self.cookiespath)
    checkout_page = mech.get('https://secure1.securebrygid.com/zgrid/proc/site/secure/crtchkoutb.jsp')
    order_info.merge!(delivery_info) unless checkout_page.search("//td[starts-with(font, 'Delivery')]/font").empty?
    form = checkout_page.form
    order_info.each do |name, value|
      form.fields.detect {|f| f.name == name.to_s}.value = value
    end
    puts mech.page.inspect
    form.submit
    puts mech.page.inspect
  end

end
