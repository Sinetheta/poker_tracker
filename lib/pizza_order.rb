#!/usr/bin/env ruby

require 'mechanize'
require 'pry'

def url_from_attributes(base_url, path, **attributes)
  url = base_url + path + "?"
  attributes.each do |attribute, value|
    url << "&" unless url[-1] == "?"
    url << attribute.to_s + "=" + value.to_s
  end
  url
end

class PizzaPage

  attr_reader :webpage, :menu_path, :item_path, :categories, :mech, :browser

  def initialize(webpage, menu_path, item_path, categories)
    @mech = Mechanize.new()
    @webpage = webpage
    @menu_path = menu_path
    @item_path = item_path
    @categories = categories
    @categories = @categories.map { |name, mnuid_it| Category.new(name, mnuid_it, self) }
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
    @page.mech.get(@url) do |page|
      page.links_with(:class => "menudetails_item_name_link").select { |link| !link.text.empty? }.each do |product|
        @products << Product.new(product.text, product.href[/\d{7}/], self)
      end
    end
  end

end

class Product

  attr_reader :name, :category, :url, :form, :fields

  def initialize(name, iid_it, category)
    @name = name
    @iid_it = iid_it
    @category = category
    @url = url_from_attributes(category.page.webpage, category.page.item_path, {:mnuid_it => category.mnuid_it, :iid_it => @iid_it})
    @form = find_form
    @fields = [text_fields, size_choices, crust_choices, crust_options, sauce_options]
  end

  def find_form
    form = nil
    @category.page.mech.get(@url) do |page|
      form = page.form('crtitmfrm')
    end
    form
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
      crust_choices[radio.text.split(" ")[0].downcase.gsub(/\'|\"/, "").to_sym] = radio
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

binding.pry
