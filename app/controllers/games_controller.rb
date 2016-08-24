class GamesController < ApplicationController
  def index
    @games = Game.all
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    if @game.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    game = Game.find(params[:id])
    game.update_attributes(game_params)
    if game.save
      flash[:alert] = "game updated"
    end
    redirect_to game_path(game)
  end

  def show
    @game = Game.find(params[:id])
    @blinds = @game.blinds.map {|small_blind| [small_blind, small_blind*2]}
    respond_to do |format|
      format.html
      format.json
    end
  end

  private
  def game_params
    params.require(:game).permit(:name, :players, :chips, :game_length, :round_length, :status, :round, :round_start)
  end
end
