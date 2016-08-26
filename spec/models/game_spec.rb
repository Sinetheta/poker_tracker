require 'rails_helper'

RSpec.describe Game, :type => :model do
  context "when creating a game" do
    it "generates a name and the blinds" do
      game = Game.new(players: 7,
                      chips: 2000,
                      game_length: 120,
                      round_length: 15,
                      smallest_denomination: 1,
                      first_small_blind: 1)
      expect(game.save).to eq(true)
      expect(game.blinds.class).to eq(Array)
      expect(game.name.class).to eq(String)
    end
  end
end
