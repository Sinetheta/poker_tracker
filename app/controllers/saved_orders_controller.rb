class SavedOrdersController < ApplicationController

  before_action :require_login

  def new
    @saved_order = SavedOrder.new
  end

  def create
    @saved_order = SavedOrder.new(saved_order_params)
    if params[:saved_order][:order_upload]
      @saved_order.order = YAML::load(params[:saved_order][:order_upload].read)
    else
      @saved_order.order = YAML::load(params[:saved_order][:order])
    end
    @saved_order.user_id = current_user.id
    if @saved_order.save
      redirect_to pizza_path
    else
      redirect_to new_saved_order_path
    end
  end

  def edit
    @saved_order = SavedOrder.find(params[:id])
  end

  def update
    @saved_order = SavedOrder.find(params[:id])
    @saved_order.order = YAML::load(params[:saved_order][:order])
    @saved_order.update_attributes(saved_order_params)
    if @saved_order.save
      redirect_to pizza_path
    else
      redirect_to new_saved_order_path
    end
  end

  def destroy
    @saved_order = SavedOrder.find(params[:id])
    @saved_order.destroy
    redirect_to pizza_path
  end

  private

  def saved_order_params
    params.require(:saved_order).permit(:name)
  end

  def require_login
    unless user_signed_in?
      flash[:alert] = "You must log in to continue"
      redirect_to new_user_session_path
    end
  end

end
