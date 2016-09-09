require 'rails_helper'

describe Player do
  it "has a valid factory" do
    expect(create(:player)).to be_valid
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
  it "has a game_id" do
    expect(build(:player, :game_id => nil)).not_to be_valid
  end
  it "references the game with it's game_id" do
    game = create(:game)
    player = create(:player, :game_id => game.id)
    expect(player.game).to eq(game)
  end
end
