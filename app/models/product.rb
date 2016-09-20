class Product < ActiveRecord::Base

  require 'url_helpers.rb'

  belongs_to :category

  validates :name, presence: true
  validates :iid_it, numericality: true

  after_validation :make_url, :on => :create

  protected

  def make_url
    self.url = url_from_attributes(self.category.pizzapage.webpage_path, self.category.pizzapage.item_path, :iid_it => self.iid_it)
  end
end
