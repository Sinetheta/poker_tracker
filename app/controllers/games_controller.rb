class GamesController < ApplicationController

  def index
    @games = Game.in_progress
    redirect_to new_game_path if @games.empty?
  end

  def show
    @game = Game.find(params[:id])
    @players = @game.users + @game.guests
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
      # If we're passed guests during creation
      if params["game"]["guest_ids"]
        params["game"]["guest_ids"].map! do |guest|
          guest = guest.downcase.capitalize
          record = Guest.find_by_name(guest)
          # If the guest already exists, store the reference
          if record
            guest = record.id
          # Otherwise, create the guest and store the reference
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

      # If we're putting a guest or a user out
      if params[:game][:users_out]
        out_hash = game.users_out.merge(params[:game][:users_out])
        game.update_attribute(:users_out, out_hash) unless params[:game][:users_out].keys.include?('undefined')
      elsif params[:game][:guests_out]
        out_hash = game.guests_out.merge(params[:game][:guests_out])
        game.update_attribute(:guests_out, out_hash) unless params[:game][:guests_out].keys.include?('undefined')
      end

      # After updating the game, see if a winner can be declared
      if game.users_out.length + game.guests_out.length == game.users.length+game.guests.length-1
        user_winner = game.users.map {|user| user.id.to_s} - game.users_out.keys
        guest_winner = game.guests.map {|user| user.id.to_s} - game.guests_out.keys
        if user_winner.empty?
          game.winner_id = guest_winner[0].to_i
          game.winner_type = "guest"
        else
          game.winner_id = user_winner[0].to_i
          game.winner_type = "user"
        end
        game.save()
      end

      flash[:alert] = "Problem updating game" unless game.update_attributes(game_params)
    else
      redirect_to new_user_session_path
    end
    respond_to do |format|
      format.html { redirect_to game_path(game) }
      format.json { render json: game }
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
    @games = Game.completed.includes(:users, :guests)
  end

  def leaderboard
    @players = User.all.includes(:games) + Guest.all.includes(:games)
  end

  private
  def game_params
    params.require(:game).permit({:user_ids => []}, {:guest_ids => []},
                                 :game_length, :round_length, :buy_in, :round,
                                 :chips, :first_small_blind, :smallest_denomination)
  end
end
