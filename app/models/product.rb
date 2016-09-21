class Product < ActiveRecord::Base

  require 'url_helpers.rb'
  require 'pizza_data_generator.rb'

  belongs_to :category

  serialize :options, Hash
  validates :name, presence: true
  validates :iid_it, numericality: true

  after_validation :make_url, :on => :create

  def generate_options
    data_gen = PizzaDataGenerator.new(self.category.pizzapage)
    self.options = data_gen.options_for_product(self)
  end

  protected

  def make_url
    self.url = url_from_attributes(self.category.pizzapage.webpage_path, self.category.pizzapage.item_path, :iid_it => self.iid_it, :mnuid_it => self.category.mnuid_it)
  end
end
