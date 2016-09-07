class GamesController < ApplicationController

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

    # If we're passed guests during creation
    (params["game"]["guests"] || []).each do |guest|
      game.players << Player.create(guest: Guest.find_or_create_by(name: guest), game_id: game.id)
    end

    (params["game"]["user_ids"] || []).each do |user|
      game.players << Player.create(user: User.find(user), game_id: game.id)
    end

    if game.save
      flash[:alert] = game.warnings[:duplicates][0]
      redirect_to game_path(game)
    else
      flash[:alert] = game.errors[:blinds][0]
      redirect_to new_game_path
    end
  end

  def update
    game = Game.find(params[:id])

    player_out ||= params[:game][:player_out]
    if player_out
      player = game.players.find(player_out.to_i)
      player.round_out = game.round
      player.winner = false
      player.save()
    end

    # See if a winner can be declared
    if game.players_out.length == game.number_of_players-1
      winner = game.players.find_by(winner: nil)
      winner.winner = true
      game.complete = true
      game.save()
      winner.save()
    end

    flash[:alert] = "Problem updating game" unless game.update_attributes(game_params)

    respond_to do |format|
      format.html { redirect_to game_path(game) }
      format.json { render json: game }
    end
  end

  def destroy
    game = Game.find(params[:id])
    game.delete
    redirect_to games_path
  end

  def archive
    @games = Game.completed
  end

  def leaderboard
    all_players = (User.all + Guest.all).map do |user|
      # If user has never played a game
      if user.players.empty?
        player = nil
      else
        wins = user.players.where(winner: true).length
        player = {player: user, wins: wins, win_perc: (wins/user.players.length.to_f)*100 }
      end
    end
    all_players.select! {|player| !player.nil?}
    @players = all_players.sort_by {|player| player[:win_perc]}.reverse
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
