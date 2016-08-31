class GamesController < ApplicationController

  def index
    @games = Game.in_progress
    redirect_to new_game_path if @games.empty?
  end

  def show
    @game = Game.find(params[:id])
    @players = @game.users
    @blinds = @game.blinds.map {|small_blind| [small_blind, small_blind*2]}
    @current_blinds = @blinds[@game.round]
    respond_to do |format|
      format.html
      format.json { render json: @game }
    end
  end

  def new
    if user_signed_in?
      @game = Game.new
      @users = User.all
    else
      redirect_to new_user_session_path
    end
  end

  def edit
    if user_signed_in?
      @game = Game.find(params[:id])
    else
      redirect_to new_user_session_path
    end
  end

  def create
    if user_signed_in?
      # Handle guest model creation
      if params["game"]["guest_ids"]
        params["game"]["guest_ids"].map! do |guest|
          record = Guest.find_by_name(guest)
          if record
            guest = record.id
          else
            record = Guest.create(name: guest)
            guest = record.id
          end
        end
      end
      game = Game.new(game_params)
      if game.save
        redirect_to game_path(game)
      else
        redirect_to new_game_path
      end
    else
      redirect_to new_user_session_path
    end
  end

  def update
    if user_signed_in?
      game = Game.find(params[:id])
      if params[:game][:players_out]
        players_out_hash = game.players_out.merge(params[:game][:players_out])
        if players_out_hash.length == game.users.length-1
          game.winner = (game.users.map {|user| user.id} - players_out_hash.keys.map {|id| id.to_i}).first()
        end
        game.update_attribute(:players_out, players_out_hash)
      end
      flash[:alert] = "Problem updating game" unless game.update_attributes(game_params)
      redirect_to game_path(game)
    else
      redirect_to new_user_session_path
    end
  end

  def destroy
    if user_signed_in?
      game = Game.find(params[:id])
      game.delete
      redirect_to games_path
    else
      redirect_to new_user_session_path
    end
  end

  def archive
    @games = Game.completed
  end

  def leaderboard
    @games = Game.all
    @users = User.all
  end

  private
  def game_params
    params.require(:game).permit({:user_ids => []}, {:guest_ids => []},
                                 :game_length, :round_length, :buy_in, :round,
                                 :chips, :first_small_blind, :smallest_denomination)
  end
end
