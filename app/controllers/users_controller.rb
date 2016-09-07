class UsersController < ApplicationController

  def history
    @user = User.find(params[:id])
    @players = @user.players

    @game_stats = []
    @won = []
    @went_out = []
    @user.players.each do |player|
      if player.game.complete == true
        game_stats = {game: player.game, round_out: player.round_out, winner: player.winner}
        @game_stats << game_stats
      end
    end

    @game_stats.each do |game|
      if game[:winner] == true
        @won << game
      else
        @went_out << game
      end
    end

    @stats = {}
    @stats[:win_perc] = (@won.length/@game_stats.length.to_f)*100

    @stats[:round_aver] = @went_out.map do |game|
      game = game[:round_out]
    end.inject(0.0) {|sum, game| sum + game } / @went_out.length

    @stats[:chips_perc] = @went_out.map do |game|
      game = (game[:game].blinds[game[:round_out]]/game[:game].total_chips.to_f)*100
    end.inject(0.0) {|sum, game| sum + game } / @went_out.length

  end
end
