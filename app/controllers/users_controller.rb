class UsersController < ApplicationController

  def history
    @user = User.find(params[:id])
    @games = @user.games.completed
    @won = @games.select {|game| game.winner_type == "user" && game.winner == @user.id.to_s}
    @went_out = @games - @won
    chips_perc = @went_out.map do |game|
      round_out = game.users_out[@user.id.to_s].to_i
      total_chips = (game.guests.length+game.users.length)*game.chips.to_f
      game = ((game.blinds[round_out]/total_chips)*100)
    end
    @chips_perc = chips_perc.inject(0.0) {|sum, game| sum + game } / chips_perc.length
    round_aver = @went_out. map do |game|
      game = game.users_out[@user.id.to_s].to_i+1
    end
    @round_aver = round_aver.inject(0.0) {|sum, game| sum + game } / round_aver.length
  end

end
