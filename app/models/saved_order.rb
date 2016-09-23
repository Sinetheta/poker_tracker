class SavedOrder < ActiveRecord::Base

  belongs_to :user

  serialize :order, Array

  validate :products_valid

  private

  def products_valid
    self.order.each do |product_selection|
      if product_selection.class != Hash
        errors.add(:order_misformed, "The order you submitted is not correctly formatted")
      else
        if Product.find_by(name: product_selection.keys[0]).nil?
          errors.add(:invalid_product, "One of the products you entered is invalid")
        end
      end
    end
  end

end
