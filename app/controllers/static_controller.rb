class StaticController < ApplicationController
  def pizza
    require 'pizza_order.rb'
    @pizza_page = PizzaPage.new()
    @categories = @pizza_page.categories
  end
end
