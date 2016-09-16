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
      @game = create(:game, :players => [create(:player), create(:player), create(:player)])
      @game.round_length = 15
      @game.save
    end

    it "updates round_length when passed as a param" do
      sign_in create(:user)

      expect {
        patch :update, :id => @game.id, :game => {:round_length => 20}
      }.to change { @game.round_length }.from(15).to(20)
    end

  end

end
