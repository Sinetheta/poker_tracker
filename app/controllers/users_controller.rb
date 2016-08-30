class UsersController < ApplicationController

  def history
    @user = User.find(params[:id])
    @games = @user.games.completed
  end

end
