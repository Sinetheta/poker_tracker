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
  end

  def edit
    @game = Game.find(params[:id])
  end

  def create
    game = Game.new(game_params)
    if game.save
      redirect_to game_path(game)
    else
      render :new
    end
  end

  def update
    game = Game.find(params[:id])
    game.update_attributes(game_params)
    if game.save
      flash[:alert] = "Game Updated" unless game_params[:round]
    end
    redirect_to game_path(game)
  end

  def destroy
    game = Game.find(params[:id])
    game.delete
    redirect_to games_path
  end

  private
  def game_params
    params.require(:game).permit(:name, :players, :chips, :game_length, :round_length, :status, :round, :round_start, :first_small_blind)
  end
end
