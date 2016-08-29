require 'rails_helper'

RSpec.describe Game, :type => :model do
  context "when creating a game" do
    it "generates a name and the blinds" do
      game = Game.new(guests: [1,2,3,4,5,6,7],
                      chips: 2000,
                      game_length: 2,
                      round_length: 15,
                      smallest_denomination: 1,
                      first_small_blind: 1)
      expect(game.save).to eq(true)
      expect(game.blinds.class).to eq(Array)
      expect(game.name.class).to eq(String)
    end
  end
end

RSpec.describe Game, :type => :model do
  context "after a game is created" do
    it "should have enough rounds to reach the game's length" do
      game = Game.new(guests: [1,2,3,4,5,6,7],
                      chips: 2000,
                      game_length: 2,
                      round_length: 15,
                      smallest_denomination: 1,
                      first_small_blind: 1)
      expect(game.save).to eq(true)
      expect((game.blinds.length+1)*game.round_length).to be > (game.game_length*60)
    end
  end
end
