require 'faker'

FactoryGirl.define do
  factory :player do |f|
    if Faker::Boolean.boolean
      f.user { create(:user) }
    else
      f.guest { create(:guest) }
    end
    f.game_id { Faker::Number.number(1) }
  end

  factory :user_player, class: Player do |f|
    f.user { create(:user) }
    f.game_id { Faker::Number.number(1) }
  end

  factory :guest_player, class: Player do |f|
    f.guest { create(:guest) }
    f.game_id { Faker::Number.number(1) }
  end
end
