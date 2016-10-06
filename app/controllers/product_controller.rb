class ProductController < ApplicationController
  def show
    @product = Product.find(params[:id])
    @sizes = @product.options[:radios]["olszid"] || []
    @sizes = [] if @sizes.length == 1
    @option1 = @product.options[:radios]["mcctstids1"] || []
    @option2 = @product.options[:radios]["mcctstids2"] || []
    @option3 = @product.options[:radios]["mcctstids3"] || []
    @takeout = @product.options[:radios]["otid"] || []
    @removals = @product.options[:checkboxes]["mcctsuids"] || []
    @additions = @product.options[:checkboxes]["mcctadids"] || []
    @text_fields = @product.options[:text_fields] || []
    @orders = current_user.saved_orders
  end

  def add_to_saved_order
    binding.pry
  end
end
