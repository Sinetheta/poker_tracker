class PizzaConfigsController < ApplicationController

  before_action :require_login

  def new
    
  end

  def edit
    
  end

  def show
    
  end

  def create

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

end
