require 'faker'

FactoryGirl.define do
  factory :game do |f|
    f.chips 2000
    f.game_length 2.5
    f.round_length 15
    f.first_small_blind 1
    f.smallest_denomination 1
    f.blinds [1]
    f.players {[Player.create(user: create(:user)), Player.create(guest: create(:guest))]}
  end
end
