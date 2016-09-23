class SavedOrdersController < ApplicationController

  before_action :require_login

  def new
    @saved_order = SavedOrder.new
  end

  def create
    @saved_order = SavedOrder.new(saved_order_params)
    @saved_order.order = YAML::load(params[:saved_order][:order])
    @saved_order.user_id = current_user.id
    if @saved_order.save
      redirect_to pizza_path
    else
      redirect_to new_saved_order_path
    end
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
