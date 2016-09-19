# Lets generate blinds in here
FactoryGirl.define do
  factory :game do |f|
    denominations = [1,5,10,25,50,100,250,500,1000]
    f.buy_in { Random.rand(10000)+1 }
    f.smallest_denomination { denominations.sample }
    f.game_length { (Random.rand(96)+8)*0.25 }
    f.chips { Random.rand(10000)+1+(2*smallest_denomination) }
    f.round_length { Random.rand(120)+1 }
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
