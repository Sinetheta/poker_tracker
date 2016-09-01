class UsersController < ApplicationController

  def history
    @user = User.find(params[:id])
    @games = @user.games.completed
    @won = @games.select {|game| game.winner_type == "user" && game.winner == @user.id.to_s}
    @went_out = @games - @won
  end

end
