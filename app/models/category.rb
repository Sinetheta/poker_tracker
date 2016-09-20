class Category < ActiveRecord::Base

  require 'url_helpers.rb'

  has_many :products
  belongs_to :pizzapage

  validates :name, presence: true
  validates :mnuid_it, numericality: true

  def url
    url_from_attributes(self.pizzapage.webpage_path, self.pizzapage.menu_path, :mnuid_it => self.mnuid_it)
  end
end
