require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe "GET index" do
    it "assigns @games" do
      game = create(:game)
      get :index
      expect(assigns(:games)).to eq([game])
    end
    it "renders the index template if there are games" do
      game = create(:game)
      get :index
      expect(response).to render_template("index")
    end
    it "redirects to new_game_path if there are no games" do
      get :index
      expect(response).to redirect_to(new_game_path)
    end
  end

  describe "POST create" do
    it "creates a game if params are valid" do
      sign_in create(:user)
      post :create, :game => attributes_for(:game, players: []).merge({:guests => ["Bob", "Joe"]})
      expect(response).to redirect_to(game_path(1))
    end
    it "redirect to new_game_path if params are invalid" do
      sign_in create(:user)
      post :create, :game => attributes_for(:game, players: []).merge({:guests => []})
      expect(response).to redirect_to(new_game_path)
    end
  end

  describe "PATCH update" do
    before :each do
      @player1 = create(:player)
      @player2 = create(:player)
      @player3 = create(:player)
      @game = create(:game, :players => [@player1, @player2, @player3])
    end

    it "updates round_length when passed as a param" do
      sign_in create(:user)
      @game.round_length = 15
      @game.save
      expect {
        patch :update, :id => @game.id, :game => {:round_length => 20}
        @game.reload
      }.to change { @game.round_length }.from(15).to(20)
    end

    it "sets a player out when passed as a param" do
      sign_in create(:user)
      expect {
        patch :update, :id => @game.id, :game => {:player_out => @player1.id}
        @player1.reload
      }.to change { @player1.winner }.from(nil).to(false)
    end

    it "sets the last player to be the winner when all but one player is set out" do
      sign_in create(:user)
      expect {
        patch :update, :id => @game.id, :game => {:player_out => @player1.id}
        patch :update, :id => @game.id, :game => {:player_out => @player2.id}
        @player3.reload
      }.to change { @player3.winner }.from(nil).to(true)
    end

    it "sets the game to be complete when all but one player is set out" do
      sign_in create(:user)
      expect {
        patch :update, :id => @game.id, :game => {:player_out => @player1.id}
        patch :update, :id => @game.id, :game => {:player_out => @player2.id}
        @game.reload
      }.to change { @game.complete }.from(false).to(true)
    end

  end

end
