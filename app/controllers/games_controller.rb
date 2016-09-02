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
      @default_values = {
        game_length: 2.5,
        round_length: 15,
        chips: 2000,
        smallest_denomination: 1,
        first_small_blind: 1,
        buy_in: 10
      }
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
        flash[:alert] = game.warnings[:duplicates][0]
        redirect_to game_path(game)
      else
        flash[:alert] = game.errors[:blinds][0]
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
        if params[:game][:players_out][:user]
          params[:game][:players_out] = {game.users.find(params[:game][:players_out][:user].keys.first.to_i) => params[:game][:players_out][:user].values.first.to_i}
          out_hash = game.players_out.merge(params[:game][:players_out])
          game.update_attribute(:players_out, out_hash)
        elsif params[:game][:players_out][:guest]
          params[:game][:players_out] = {game.guests.find(params[:game][:players_out][:guest].keys.first.to_i) => params[:game][:players_out][:guest].values.first.to_i}
          out_hash = game.players_out.merge(params[:game][:players_out])
          game.update_attribute(:players_out, out_hash)
        end
      end

      # After updating the game, see if a winner can be declared
      if game.players_out.length == game.number_of_players-1
        winner = (game.players - game.players_out.keys)[0]
        game.winner_id = winner.id
        if winner.class == Guest
          game.winner_type = "guest"
        elsif winner.class == User
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
    players = (User.all.includes(:games) + Guest.all.includes(:games)).map do |player|
      player = [player.name, Game.winner(player).length]
    end
    @players = players.sort_by {|player| player[1]}.reverse
  end

  private
  def game_params
    params.require(:game).permit({:user_ids => []}, {:guest_ids => []},
                                 :game_length, :round_length, :buy_in, :round,
                                 :chips, :first_small_blind, :smallest_denomination)
  end
end
