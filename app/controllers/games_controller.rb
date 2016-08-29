class GamesController < ApplicationController

  def index
    @games = Game.all
    redirect_to new_game_path if @games.empty?
  end

  def show
    @game = Game.find(params[:id])
    @blinds = @game.blinds.map {|small_blind| [small_blind, small_blind*2]}
    @current_blinds = @blinds[@game.round]
    respond_to do |format|
      format.html
      format.json { render json: @game }
    end
  end

  def new
    @game = Game.new
    @users = User.all
  end

  def edit
    @game = Game.find(params[:id])
  end

  def create
    game = Game.new(game_params)
    if game.save
      redirect_to game_path(game)
    else
      redirect_to new_game_path
    end
  end

  def update
    game = Game.find(params[:id])
    flash[:alert] = "Problem updating game" unless game.update_attributes(game_params)
    redirect_to game_path(game)
  end

  def destroy
    game = Game.find(params[:id])
    game.delete
    redirect_to games_path
  end

  private
  def game_params
    params["game"]["guests"] = params["game"]["guests"].map {|t| t.strip} if params["game"]["guests"]
    params["game"]["user_ids"] = params["game"]["user_ids"].uniq if params["game"]["user_ids"]
    params.require(:game).permit(:name, :chips, :winner, {:guests => []},
                                 :game_length, :round_length, {:user_ids => []},
                                 :round, :first_small_blind, :smallest_denomination)
  end
end
