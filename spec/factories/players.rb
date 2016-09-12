FactoryGirl.define do
  factory :player do |f|
    f.user { create(:user) }
    f.guest { create(:guest) }
  end

  factory :user_player, class: Player do |f|
    f.user { create(:user) }
  end

  factory :guest_player, class: Player do |f|
    f.guest { create(:guest) }
  end
end
