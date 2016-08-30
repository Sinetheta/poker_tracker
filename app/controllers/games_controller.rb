class GamesController < ApplicationController

  def index
    @games = Game.select {|game| game.winner == nil}
    redirect_to new_game_path if @games.empty?
  end

  def show
    @game = Game.find(params[:id])
    @winner = nil
    @players = (@game.guests+@game.users.map {|user| user.name}).sort
    if @game.players_out.length == @players.length-1
      @winner = @players.find {|user| !@game.players_out.include?(user)}
      @game.update_attribute(:winner, @winner) unless @game.winner
    end
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
    @games = Game.all.select {|game| game.winner != nil}
  end

  def leaderboard
    @games = Game.all
    @players = {}
    @games.each do |game|
      (game.guests+game.users.map {|user| user.name}).each do |player|
        @players[player] = (@games.select {|game| game.winner == player}).length unless @players.keys.include?(player)
      end
    end
    @players = @players.sort_by {|player, wins| wins}.reverse
  end

  private
  def game_params
    params["game"]["guests"] = params["game"]["guests"].map {|t| t.strip} if params["game"]["guests"]
    params["game"]["user_ids"] = params["game"]["user_ids"].uniq if params["game"]["user_ids"]
    params.require(:game).permit(:name, :chips, {:guests => []}, {:user_ids => []},
                                 :game_length, :round_length,
                                 :round, :first_small_blind, :smallest_denomination)
  end
end
