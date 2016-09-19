
class UsersController < ApplicationController

  require 'owner_stats.rb'

  def history
    @user = User.find(params[:id])
    @stats = OwnerStats.new(@user)
  end
end
