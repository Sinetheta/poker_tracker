class Pizzapage < ActiveRecord::Base

  require 'url_helpers.rb'
  require 'pizza_data_generator.rb'

  has_many :categories

  validates :webpage_path, :menu_path, :item_path, :checkout_path, presence: true

  def create_categories_and_products
    generator = PizzaDataGenerator.new(self)
  end

  def checkout_url
    url_from_attributes(self.webpage_path, self.checkout_path)
  end
end
