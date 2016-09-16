require "rails_helper"

describe Game do

  it "has a valid factory" do
    expect(create(:game)).to be_valid
  end

  it "has a name" do
    expect(create(:game).name).not_to be_nil
  end

  it "has some players" do
    expect(create(:game).players.length).to be >= 2
  end

  describe "putting players out" do
    let(:player1) { create(:player) }
    let(:player2) { create(:player) }
    let(:player3) { create(:player) }
    let(:game) { create(:game, :players => [player1, player2, player3]) }
    before :each do
      game.round = Random.rand(game.blinds.length)
      game.save
    end

    it "will set a player to be out" do
      game.set_player_out(player1)
      expect(game.players_out).to include(player1)
    end

    it "will set a player's round_out to the current game round" do
      game.set_player_out(player1)
      expect(game.players.find(player1.id).round_out).to eq(game.round)
    end

    it "will cause the one remaining player to become a winner" do
      game.set_player_out(player1)
      game.set_player_out(player2)
      winner = (game.players - [player1, player2])[0]
      expect(winner.winner).to be true
    end

    it "will become a completed game when all but one player have gone out" do
      expect {
        game.set_player_out(player1)
        game.set_player_out(player2)
      }.to change { game.complete }.from(false).to(true)
    end

  end

  #it "has blinds that will reach 5% of total chips within 1 round of game_length" do
  #  game = create(:game)
  #  blinds_before_game_end = game.blinds.select {|blind| blind <= game.total_chips*0.05}
  #  expect(((blinds_before_game_end.length-1)*game.round_length) - (game.game_length*60)).to be <= (game.round_length)
  #end

  it "cannot have a round_length greater then it's game_length" do
    expect(build(:game, :game_length => 1, :round_length => 61)).not_to be_valid
  end

end
