require 'rails_helper'

describe Player do

  it "has a valid user factory" do
    expect(create(:user_player)).to be_valid
  end

  it "has a valid guest factory" do
    expect(create(:guest_player)).to be_valid
  end

  it "can be owned by a user" do
    expect(create(:user_player)).to be_valid
  end

  it "can be owned by a guest" do
    expect(create(:guest_player)).to be_valid
  end

  it "cannot be owned by both a guest and a user" do
    expect(build(:player, :user => create(:user), :guest => create(:guest))).not_to be_valid
  end

  it "references the game it's created with" do
    game = create(:game)
    player = game.players.sample
    expect(player.game).to eq(game)
  end

  describe "when going out" do
    before :each do
      @game = create(:game)
      @game.round = Random.rand(@game.blinds.length)
      @first_out = @game.players.sample
      @second_out = (@game.players - [@first_out]).sample
      @first_out.go_out()
      @second_out.go_out()
    end

    it "will go out on the round the game is on" do
      expect(@second_out.round_out).to eq(@game.round)
    end

    it "will go out in it's ranked position" do
      expect(@second_out.position_out).to eq(@first_out.position_out+1)
    end
  end

end
