require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe "GET index" do
    let(:game) { create(:game) }

    it "assigns @games" do
      game
      get :index
      expect(assigns(:games)).to eq([game])
    end

    it "renders the index template if there are games" do
      game
      get :index
      expect(response).to render_template("index")
    end

    it "redirects to new_game_path if there are no games" do
      get :index
      expect(response).to redirect_to(new_game_path)
    end
  end

  describe "GET show" do
    let (:game) { create(:game) }
    before :each do
      game
    end

    it "renders the show template with html format" do
      get :show, :id => game.id, :format => 'html'
      expect(response).to render_template("show")
    end

    it "renders the game object as json with json format" do
      get :show, :id => game.id, :format => 'json'
      parse_json = JSON(response.body)
      expect(parse_json).to include("id", "name", "blinds")
    end

    it "assigns @game" do
      get :show, :id => game.id
      expect(assigns(:game)).to eq(game)
    end

    it "assigns @players" do
      get :show, :id => game.id
      expect(assigns(:players)).to eq(game.players)
    end

    it "assigns @blinds" do
      blinds = game.blinds.map {|small_blind| [small_blind, small_blind*2]}
      get :show, :id => game.id
      expect(assigns(:blinds)).to eq(blinds)
    end
  end

  describe "GET new" do
    let(:user) { create(:user) }
    before :each do
      user
    end

    it "renders the new template" do
      sign_in user
      get :new
      expect(response).to render_template("new")
    end

    it "assigns @users" do
      sign_in user
      get :new
      expect(assigns(:users)).to eq([user])
    end

    it "assigns default values" do
      sign_in user
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

  describe "GET edit" do
    let(:game) { create(:game) }
    let(:user) { create(:user) }
    before :each do
      game
    end

    it "renders the edit template if logged in" do
      sign_in user
      get :edit, :id => game.id
      expect(response).to render_template("edit")
    end

    it "redirects to the sign in page if not logged in" do
      get :edit, :id => game.id
      expect(response).to redirect_to(new_user_session_path)
    end

    it "assigns @game" do
      sign_in user
      get :edit, :id => game.id
      expect(assigns(:game)).to eq(game)
    end

  end

  describe "POST create" do
    let(:user) { create(:user) }
    let(:game_attributes) { attributes_for(:game, players: []) }

    it "assigns @game to a new instance of game" do
      sign_in user
      post :create, :game => game_attributes
      expect(assigns(:game)).to be_a_new(Game)
    end

    it "persists a new game if supplied at least 2 of either guests or user_ids" do
      sign_in user
      post :create, :game => game_attributes.merge({:guests => ["Bob"], :user_ids => [user.id]})
      expect(assigns(:game)).to be_persisted
    end

    it "redirects to the path of a created game" do
      sign_in user
      post :create, :game => game_attributes.merge({:guests => ["Bob", "Joe"], :user_ids => [user.id]})
      expect(response).to redirect_to(game_path(assigns(:game).id))
    end

    it "redirects to new_game_path if not enough players" do
      sign_in user
      post :create, :game => game_attributes.merge({:guests => [], :user_ids => []})
      expect(response).to redirect_to(new_game_path)
    end

  end

  describe "PATCH update" do
    let(:player1) { create(:player) }
    let(:player2) { create(:player) }
    let(:player3) { create(:player) }
    let(:game) { create(:game, :players => [player1, player2, player3]) }
    let(:user) { create(:user) }

    it "updates round_length when passed as a param" do
      sign_in user
      game.round_length = 15
      game.save
      expect {
        patch :update, :id => game.id, :game => {:round_length => 20}
        game.reload
      }.to change { game.round_length }.from(15).to(20)
    end

    it "sets a player out when passed as a param" do
      sign_in user
      expect {
        patch :update, :id => game.id, :game => {:player_out => player1.id}
        player1.reload
      }.to change { player1.winner }.from(nil).to(false)
    end

    it "sets the last player to be the winner when all but one player is set out" do
      sign_in user
      expect {
        patch :update, :id => game.id, :game => {:player_out => player1.id}
        patch :update, :id => game.id, :game => {:player_out => player2.id}
        player3.reload
      }.to change { player3.winner }.from(nil).to(true)
    end

    it "sets the game to be complete when all but one player is set out" do
      sign_in user
      expect {
        patch :update, :id => game.id, :game => {:player_out => player1.id}
        patch :update, :id => game.id, :game => {:player_out => player2.id}
        game.reload
      }.to change { game.complete }.from(false).to(true)
    end

    it "renders the game object as json with json format" do
      sign_in user
      patch :update, :id => game.id, :format => 'json'
      parse_json = JSON(response.body)
      expect(parse_json).to include("id", "name", "blinds")
    end
  end

  describe "DELETE destory" do
    let(:game) { create(:game) }
    let(:user) { create(:user) }

    it "causes the passed game to be deleted" do
      sign_in user
      game
      delete :destroy, :id => game.id
      expect { game.reload }.to raise_exception ActiveRecord::RecordNotFound
    end

    it "redirect a signed in user to games_path" do
      sign_in user
      game
      delete :destroy, :id => game.id
      expect(response).to redirect_to(games_path)
    end

    it "redirects to sign in if not signed in" do
      game
      delete :destroy, :id => game.id
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "GET archive" do
    let(:complete_game) { create(:game, :complete => true)}
    let(:game) { create(:game) }

    it "assigns @games with completed games" do
      complete_game
      game
      get :archive
      expect(assigns(:games)).to eq([complete_game])
    end

    it "renders the archive template" do
      get :archive
      expect(response).to render_template(:archive)
    end
  end

  describe "GET leaderboard" do
    let(:player1) { create(:player) }
    let(:player2) { create(:player) }
    let(:player3) { create(:player) }
    let(:game) { create(:game, :players => [player1, player2, player3]) }
    let(:user) { create(:user) }

    before :each do
      game.set_player_out(player1)
      game.set_player_out(player2)
    end

    it "assigns @owners_stats with a stats object for each owner who participated in a completed game" do
      get :leaderboard
      expect(assigns(:owner_stats).length).to eq(game.players.length)
    end

    it "renders the leaderboard template" do
      get :leaderboard
      expect(response).to render_template(:leaderboard)
    end

  end

end
