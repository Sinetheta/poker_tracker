class UsersController < ApplicationController

  def history
    @user = User.find(params[:id])
    @players = @user.players.includes(game: {players: [:user, :guest]})

    @stats = UserStats.new(@players)
  end
end

class UserStats

  attr_reader :round_out_average, :chips_out_perc, :win_perc

  def initialize(players)
    @players = players
    @games_won = []
    @games_lost = []
    @round_out_average = nil
    @chips_out_perc = nil
    @win_perc = nil
    lifetime_stats()
  end

  # Assign lifetime stats
  def lifetime_stats
    rounds_out = []
    chips_round_out = []
    @players.each do |player|
      if player.winner
        @games_won << player.game
      elsif player.winner == false
        @games_lost << player.game
        rounds_out << player.round_out+1
        chips_round_out << (player.game.blinds[player.round_out]/player.game.total_chips.to_f)*100
      end
    end
    @round_out_average = rounds_out.sum / rounds_out.length.to_f
    @chips_out_perc = chips_round_out.sum / chips_round_out.length
    @win_perc = (@games_won.length/@players.length.to_f)*100
  end

  def player_stats(player)
    if player.winner
      {winner: true, round_out: nil, chips_perc: nil}
    elsif player.winner == false
      chips_perc = (player.game.blinds[player.round_out]/player.game.total_chips.to_f)*100
      {winner: false, round_out: player.round_out, chips_perc: chips_perc}
    end
  end
end
