require 'faker'

# Lets generate blinds in here
FactoryGirl.define do
  factory :game do |f|
    denominations = [1,5,10,25,50,100,250,500,1000,2000,5000]
    smallest_denomination = denominations.sample
    game_length = (Random.rand(480)+1)*0.05
    f.chips { Random.rand(100000)+1 }
    f.game_length game_length
    f.round_length { Random.rand(game_length*60).to_i+1 }
    f.smallest_denomination smallest_denomination
    f.first_small_blind { denominations.select {|denom| denom >= smallest_denomination}.sample }
    f.players {
      players = []
      (Random.rand(20)+2).times { players << create(:player) }
      players
    }
  end
end
