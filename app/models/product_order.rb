class ProductOrder < ActiveRecord::Base

  belongs_to :product
  belongs_to :cart

  serialize :options
  validates :options, presence: true
end
