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
end
