require 'rails_helper'

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
  it "has enough rounds to reach it's length" do
    game = create(:game)
    expect(game.round_length * game.blinds.length).to be >= (game.game_length*60)
  end
  it "cannot have a round_length greater then it's game_length" do
    expect(build(:game, :game_length => 1, :round_length => 61)).not_to be_valid
  end
  it "cannot have a first_small_blind less than smallest_denomination" do
    expect(build(:game, :smallest_denomination => 25, :first_small_blind => 10)).not_to be_valid
  end
end
