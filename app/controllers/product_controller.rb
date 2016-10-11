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
    line_item = { params[:name] => { :radios =>
                                     { "olszid" => params[:size],
                                       "mcctstids1" => params[:option1],
                                       "mcctstids2" => params[:option2],
                                       "mcctstids3" => params[:option3],
                                       "otid" => params[:takeout] },
                                     :checkboxes =>
                                     { "mcctsuids" => (params[:removals] || []),
                                       "mcctadids" => (params[:additions] || []) },
                                     :text_fields =>
                                     { "olytq" => params[:quantity],
                                       "olfnm" => params[:name_for],
                                       "olynt" => params[:instructions] }}}
    if params[:order_id].empty?
      order = SavedOrder.new(user_id: current_user.id, name: params[:name], order: [line_item])
    else
      order = SavedOrder.find(params[:order_id].to_i)
      order.order << line_item
    end
    order.save
    redirect_to pizza_path
  end
end
