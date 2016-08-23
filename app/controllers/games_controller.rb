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
    @game = Game.find(params[:id])
    @game.status = game_params[:status]
    if @game.save
      flash[:alert] = "game updated"
    end
    redirect_to games_path
  end

  def show
    @game = Game.find(params[:id])
    @blinds = @game.blinds.map {|small_blind| [small_blind, small_blind*2]}
  end

  private
  def game_params
    params.require(:game).permit(:name, :players, :chips, :game_length, :round_length, :status)
  end
end
