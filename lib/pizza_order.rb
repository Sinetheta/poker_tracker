#!/usr/bin/env ruby

require 'mechanize'
require 'vcr'
require 'pry'

VCR.configure do |c|
  c.cassette_library_dir = 'vcr_cassettes'
  c.allow_http_connections_when_no_cassette = true
  c.hook_into :webmock
end

def get_page(name, url)
  VCR.use_cassette(name) do
    a = Mechanize.new
    a.get(url)
  end
end

def url_from_attributes(base_url, path, **attributes)
  url = base_url + path + "?"
  attributes.each do |attribute, value|
    url << "&" unless url[-1] == "?"
    url << attribute.to_s + "=" + value.to_s
  end
  url
end

class PizzaPage

  attr_reader :webpage, :menu_path, :item_path, :categories, :browser, :mech

  def initialize(webpage, menu_path, item_path, checkout_path, categories)
    @mech = Mechanize.new
    @webpage = webpage
    @menu_path = menu_path
    @item_path = item_path
    @checkout_path = checkout_path
    @categories = categories
    @categories = @categories.map { |name, mnuid_it| Category.new(name, mnuid_it, self) }
  end

  def get_checkout_total
    checkout = @mech.get(url_from_attributes(@webpage, @checkout_path))
    checkout.search("//font[starts-with(b, '$')]/b").text.gsub(/\$|\./, "").to_i/100.0
  end

end

class Category

  attr_reader :name, :mnuid_it, :page, :products, :url

  def initialize(name, mnuid_it, page)
    @name = name
    @mnuid_it = mnuid_it
    @page = page
    @products = []
    @url = url_from_attributes(page.webpage, page.menu_path, {:mnuid_it => @mnuid_it})
    find_products
  end

  def find_products
    products = []
    page = get_page("category_#{mnuid_it}", @url)
    page.links_with(:class => "menudetails_item_name_link").select { |link| !link.text.empty? }.each do |product|
      @products << Product.new(product.text, product.href[/\d{7}/], self)
    end
  end

end

class LineItem

  attr_reader :options, :text_fields, :product

  def initialize(product)
    @product = product
    @options = []
    @text_fields = {}
  end

  def add_options(option, *selection)
    if @product.fields[option]
      selection.each do |selection|
        @options << @product.fields[option][selection] unless @product.fields[option][selection].nil?
      end
    end
  end

  def add_text_option(field, value)
    form_field = @product.fields[:text_fields][field]
    @text_fields[form_field] = value unless form_field.nil?
  end

  def add_to_cart
    @options.each do |option|
      option.click
    end
    @text_fields.each do |field, value|
      field.value = value
    end
    @product.form.submit
  end

end

class Product

  attr_reader :name, :category, :url, :form, :fields, :iid_it, :line_item

  def initialize(name, iid_it, category)
    @name = name
    @iid_it = iid_it
    @category = category
    @url = url_from_attributes(category.page.webpage, category.page.item_path, {:mnuid_it => category.mnuid_it, :iid_it => @iid_it})
    @form = find_form
    @fields = all_fields
    @line_item = nil
  end

  def build_line_item
    @form = find_form_http
    @fields = all_fields
    @line_item = LineItem.new(self)
  end

  def find_form
    get_page("product_#{@iid_it}", @url).form('crtitmfrm')
  end

  def find_form_http
    @category.page.mech.get(@url).form('crtitmfrm')
  end

  def all_fields
    {delivery_choice: delivery_choice, text_fields: text_fields,
     size_choices: size_choices, crust_choices: crust_choices,
     crust_options: crust_options, sauce_options: sauce_options,
     add_ingredients: add_ingredients, remove_ingredients: remove_ingredients}
  end

  def remove_ingredients
    ingredients = {}
    @form.checkboxes.select do |checkbox|
      checkbox.name == "mcctsuids"
    end.each do |checkbox|
      ingredients[checkbox.text.tr(" ", "_").to_sym] = checkbox
    end
    ingredients
  end

  def add_ingredients
    ingredients = {}
    @form.checkboxes.select do |checkbox|
      checkbox.name == "mcctadids"
    end.each do |checkbox|
      ingredients[checkbox.text.tr(" ", "_").to_sym] = checkbox
    end
    ingredients
  end

  def text_fields
    text_fields = {}
    @form.fields.select do |field|
      field.class != Mechanize::Form::Hidden
    end.each do |field|
      text_fields[field.name.to_sym] = field
    end
    text_fields
  end

  def delivery_choice
    delivery_choice = {}
    @form.radiobuttons.select do |radio|
      radio.name == "otid"
    end.map do |radio|
      delivery_choice[radio.text.downcase.to_sym] = radio
    end
    delivery_choice
  end

  def size_choices
    size_choices = {}
    @form.radiobuttons.select do |radio|
      radio.name == "olszid"
    end.map do |radio|
      size_choices[radio.text.downcase.gsub(/\$/, "").to_sym] = radio
    end
    size_choices
  end

  def crust_choices
    crust_choices = {}
    @form.radiobuttons.select do |radio|
      radio.name == "mcctstids1"
    end.map do |radio|
      crust_choices[radio.text.downcase.tr(" ", "_").gsub(/\'|\"/, "").to_sym] = radio
    end
    crust_choices
  end

  def crust_options
    crust_options = {}
    @form.radiobuttons.select do |radio|
      radio.name == "mcctstids2"
    end.map do |radio|
      crust_options[radio.text.downcase.tr(" ", "_").gsub(/\'|\"/, "").to_sym] = radio
    end
    crust_options
  end

  def sauce_options
    sauce_options = {}
    @form.radiobuttons.select do |radio|
      radio.name == "mcctstids3"
    end.map do |radio|
      sauce_options[radio.text.downcase.tr(" ", "_").gsub(/\'|\"/, "").to_sym] = radio
    end
    sauce_options
  end

end
