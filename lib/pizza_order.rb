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

  attr_reader :webpage, :menu_path, :item_path, :categories, :mech

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

  attr_reader :name, :category, :url

  def initialize(name, iid_it, category)
    @name = name
    @iid_it = iid_it
    @category = category
    @url = url_from_attributes(category.page.webpage, category.page.item_path, {:mnuid_it => category.mnuid_it, :iid_it => @iid_it})
  end

  def find_options
    form = nil
    @category.page.mech.get(@url) do |page|
      form = page.form('crtitmfrm')
    end
    form
  end

end

binding.pry
