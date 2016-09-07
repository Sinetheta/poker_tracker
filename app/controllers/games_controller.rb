class GamesController < ApplicationController

  require 'blinds.rb'

  before_action :require_login, :except => [:index, :show, :leaderboard, :archive]

  def index
    @games = Game.in_progress
    redirect_to new_game_path if @games.empty?
  end

  def show
    @game = Game.find(params[:id])
    @players = @game.players
    @blinds = @game.blinds.map {|small_blind| [small_blind, small_blind*2]}
    @current_blinds = @blinds[@game.round]

    respond_to do |format|
      format.html { }
      format.json { render json: @game }
    end
  end

  def new
    @game = Game.new
    @users = User.all
    @default_values = {
      game_length: 2.5,
      round_length: 15,
      chips: 2000,
      smallest_denomination: 1,
      first_small_blind: 1,
      buy_in: 10
    }
  end

  def edit
    @game = Game.find(params[:id])
  end

  def create
    game = Game.new(game_params, blinds: [1])

    # Create the players as part of the game
    (params["game"]["guests"] || []).each do |guest|
      game.players << Player.create(guest: Guest.find_or_create_by(name: guest), game_id: game.id)
    end
    (params["game"]["user_ids"] || []).each do |user|
      game.players << Player.create(user: User.find(user), game_id: game.id)
    end

    if game.valid?
      blinds = generate_blinds(game.game_length, game.round_length,
                              game.total_chips, game.smallest_denomination,
                              game.first_small_blind)
      game.blinds = blinds[:blinds]
      if game.round_length != blinds[:round_length]
        flash[:alert] = "Round length automatically adjusted"
        game.round_length = blinds[:round_length]
      end
    end

    if game.save
      redirect_to game_path(game)
    else
      flash[:alert] = game.errors.full_messages
      redirect_to new_game_path
    end
  end

  def update
    game = Game.find(params[:id])

    # Mark a player out
    player_out ||= params[:game][:player_out]
    if player_out
      player = game.players.find(player_out.to_i)
      player.round_out = game.round
      player.position_out = game.players_out.length
      player.winner = false
      player.save()
      # See if a winner can be declared
      if game.players_out.length+1 == game.number_of_players-1
        winner = game.players.find_by(winner: nil)
        winner.winner = true
        game.complete = true
        game.save()
        winner.save()
      end
    end

    puts "\n #{game.players_out.length} -- #{game.number_of_players-1} \n"


    flash[:alert] = "Problem updating game" unless game.update_attributes(game_params)

    respond_to do |format|
      format.html { redirect_to game_path(game) }
      format.json { render json: game }
    end
  end

  def destroy
    game = Game.find(params[:id])
    game.destroy
    redirect_to games_path
  end

  def archive
    @games = Game.completed
  end

  def leaderboard
    all_owners = (User.all + Guest.all).map do |owner|
      # If user has never played a game
      if owner.players.empty?
        owner = nil
      else
        wins = owner.players.where(winner: true).length
        owner = {player: owner, wins: wins, win_perc: (wins/owner.players.length.to_f)*100 }
      end
    end
    all_owners.select! {|owner| !owner.nil?}
    @players = all_owners.sort_by {|player| player[:win_perc]}.reverse
  end

  private
  def game_params
    params.require(:game).permit(:game_length, :round_length, :buy_in, :round,
                                 :chips, :first_small_blind, :smallest_denomination)
  end

  def require_login
    unless user_signed_in?
      flash[:alert] = "You must log in to continue"
      redirect_to new_user_session_path
    end
  end

end
