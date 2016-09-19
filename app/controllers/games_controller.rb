class GamesController < ApplicationController

  require 'owner_stats.rb'

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
      format.html { render "show" }
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
    @game = Game.new(game_params)

    # Create the players as part of the game
    (params["game"]["guests"] || []).each do |guest|
      @game.players << Player.create(guest: Guest.find_or_create_by(name: guest))
    end
    (params["game"]["user_ids"] || []).each do |user|
      @game.players << Player.create(user: User.find(user))
    end

    if @game.save
      redirect_to game_path(@game)
    else
      flash[:alert] = @game.errors.full_messages
      redirect_to new_game_path
    end
  end

  def update
    game = Game.find(params[:id])

    if params[:game]
      # Mark a player out
      if player_out = params[:game][:player_out]
        player_out = game.players.detect {|player| player.id == player_out.to_i}
        game.set_player_out(player_out)
      end

      # Clear saved_timer if changing round_length
      if params[:game][:round_length] && game.saved_timer
        game.saved_timer = nil
      end

      game.update_attributes(game_params)
    end

    unless game.save
      flash[:alert] = game.errors.full_messages
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
    @owner_stats = []
    (User.all.includes(:players) + Guest.all.includes(:players)).each do |owner|
      if owner.players.select {|player| !player.winner.nil?}.length > 0
        @owner_stats << OwnerStats.new(owner)
      end
    end
    @owner_stats.sort_by! {|stats| stats.win_perc }.reverse!
  end

  private
  def game_params
    params.require(:game).permit(:game_length, :round_length, :buy_in, :round, :name, :saved_timer,
                                 :chips, :first_small_blind, :smallest_denomination)
  end

  def require_login
    unless user_signed_in?
      flash[:alert] = "You must log in to continue"
      redirect_to new_user_session_path
    end
  end

end
