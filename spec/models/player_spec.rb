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


end
