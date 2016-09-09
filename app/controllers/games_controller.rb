class GamesController < ApplicationController

  require 'generated_game_attributes.rb'

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
    game = Game.new(game_params)

    # Create the players as part of the game
    (params["game"]["guests"] || []).each do |guest|
      game.players << Player.create(guest: Guest.find_or_create_by(name: guest), game_id: game.id)
    end
    (params["game"]["user_ids"] || []).each do |user|
      game.players << Player.create(user: User.find(user), game_id: game.id)
    end

    game.blinds = [1]
    if game.valid?
      attributes = GeneratedGameAttributes.new(game)
      game.blinds = attributes.blinds
      game.name = attributes.name
      if game.round_length != attributes.round_length
        flash[:alert] = "Round length automatically adjusted"
        game.round_length = attributes.round_length
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
      player.go_out()
      # See if a winner can be declared
      if game.players_out.length+1 == game.number_of_players-1
        winner = game.players.find_by(winner: nil)
        winner.winner = true
        game.complete = true
        game.save()
        winner.save()
      end
    end

    if game.update_attributes(game_params)
      if params[:game][:blinds] == "1"
        attributes = GeneratedGameAttributes.new(game)
        game.blinds = attributes.blinds
        if game.round_length != attributes.round_length
          flash[:alert] = "Round length automatically adjusted"
          game.round_length = attributes.round_length
        end
        flash[:alert] = game.errors.full_messages unless game.save
      end
    else
      flash[:alert] = "Problem updating game"
    end

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
    @games = Game.completed.includes(:players => [:user, :guest])
  end

  def leaderboard
    all_owners = (User.all.includes(:players) + Guest.all.includes(:players)).map do |owner|
      # If user has never played a game
      if owner.players.empty?
        owner = nil
      else
        wins = owner.players.select {|player| player.winner == true}.length
        owner = {player: owner, wins: wins, win_perc: (wins/owner.players.length.to_f)*100 }
      end
    end
    all_owners.select! {|owner| !owner.nil?}
    @players = all_owners.sort_by {|player| player[:win_perc]}.reverse
  end

  private
  def game_params
    params.require(:game).permit(:game_length, :round_length, :buy_in, :round, :name,
                                 :chips, :first_small_blind, :smallest_denomination)
  end

  def require_login
    unless user_signed_in?
      flash[:alert] = "You must log in to continue"
      redirect_to new_user_session_path
    end
  end

end
