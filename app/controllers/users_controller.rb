class UsersController < ApplicationController

  def history
    @user = User.find(params[:id])
    @won = Game.winner(@user)
    @went_out = @user.games.completed - @won
    @chips_perc = @went_out.map do |game|
      game = ((game.blinds[game.player_out_round(@user)]/game.total_chips.to_f)*100)
    end.inject(0.0) {|sum, game| sum + game } / @went_out.length
    @round_aver = @went_out.map do |game|
      game = game.player_out_round(@user)+1
    end.inject(0.0) {|sum, game| sum + game } / @went_out.length
  end

end
