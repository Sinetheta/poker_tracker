# Lets generate blinds in here
FactoryGirl.define do
  factory :game do |f|
    denominations = [1,5,10,25,50,100,250,500,1000,2000,5000]
    f.smallest_denomination { denominations.sample }
    f.first_small_blind { denominations.select {|denom| denom >= smallest_denomination}.sample }
    f.game_length { (Random.rand(96)+1)*0.25 }
    f.chips { Random.rand(10000)+1+(2*first_small_blind) }
    f.round_length { Random.rand((game_length*60).to_i)+1 }
    f.players do
      players = []
      (Random.rand(20)+6).times do
        if Random.rand(2) == 0
          players << create(:user_player)
        else
          players << create(:guest_player)
        end
      end
      players
    end
  end
end
