class PizzaConfigsController < ApplicationController

  before_action :require_login

  def new
    if current_user.pizza_config != nil
      redirect_to edit_pizza_config_path
    end
  end

  def edit
  end

  def create
    @pizza_config = PizzaConfig.new(config_params)
    @pizza_config.user = current_user
    @pizza_config.save
  end

  def update

  end

  def destory

  end

  private

  def require_login
    unless user_signed_in?
      flash[:alert] = "You must log in to continue"
      redirect_to new_user_session_path
    end
  end

  def config_params
    params.require(:pizza_config).permit(:first_name, :last_name, :company, :phone_number, :email, :address, :buzzer,
                                         :city, :postal_code, :payment_method, :ordernote,
                                         :webpage_path, :menu_path, :item_path, :checkout_path)
  end

end
