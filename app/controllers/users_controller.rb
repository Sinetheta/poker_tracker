class UsersController < ApplicationController

  def history
    @user = User.find(params[:id])
    @players = @user.players

    @games = []
    @won = []
    @went_out = []
    @user.players.each do |player|
      @games << player.game if player.game.complete == true
    end

    @games.each do |game|
      if @players.include?(game.winner)
        @won << game
      else
        @went_out << game
      end
    end

    @stats = {}
    @stats[:win_perc] = (@won.length/@games.length.to_f)*100

    @stats[:round_aver] = @went_out.map do |game|
      player = @players.find_by(game: game)
      game = player.round_out+1
    end.inject(0.0) {|sum, game| sum + game } / @went_out.length

    @stats[:chips_perc] = @went_out.map do |game|
      player = @players.find_by(game: game)
      game = (game.blinds[player.round_out]/game.total_chips.to_f)*100
    end.inject(0.0) {|sum, game| sum + game } / @went_out.length

  end
end
