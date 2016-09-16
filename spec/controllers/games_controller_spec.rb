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

  describe "GET show" do
    before :each do
      @game = create(:game)
    end

    it "renders the show template with html format" do
      get :show, :id => @game.id, :format => 'html'
      expect(response).to render_template("show")
    end

    it "renders the game object as json with json format" do
      get :show, :id => @game.id, :format => 'json'
      parse_json = JSON(response.body)
      expect(parse_json).to include("id", "name", "blinds")
    end

    it "assigns @game" do
      get :show, :id => @game.id
      expect(assigns(:game)).to eq(@game)
    end

    it "assigns @players" do
      get :show, :id => @game.id
      expect(assigns(:players)).to eq(@game.players)
    end

    it "assigns @blinds" do
      @blinds = @game.blinds.map {|small_blind| [small_blind, small_blind*2]}
      get :show, :id => @game.id
      expect(assigns(:blinds)).to eq(@blinds)
    end
  end

  describe "GET new" do
    before :each do
      @user = create(:user)
    end

    it "renders the new template" do
      sign_in @user
      get :new
      expect(response).to render_template("new")
    end

    it "assigns @users" do
      sign_in @user
      get :new
      expect(assigns(:users)).to eq([@user])
    end

    it "assigns default values" do
      sign_in @user
      get :new
      expect(assigns(:default_values)).to include(:game_length, :round_length,
                                                 :chips, :smallest_denomination,
                                                 :first_small_blind, :buy_in)
    end

    it "redirects to sign in if not signed in" do
      get :new
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "POST create" do
    it "creates a game if params are valid" do
      sign_in create(:user)
      post :create, :game => attributes_for(:game, players: []).merge({:guests => ["Bob", "Joe"]})
      expect(response).to redirect_to(game_path(1))
    end

    it "redirects to new_game_path if params are invalid" do
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
